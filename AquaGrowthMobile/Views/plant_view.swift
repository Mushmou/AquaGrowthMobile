import SwiftUI

struct PlantView: View {
    
    @State private var isShowingCreatePlantView = false
    //temp var to go with more info button
    @State private var selectedOption: String? = nil
    @StateObject var viewModel = plant_viewmodel()
    @EnvironmentObject var bluetooth_viewModel: bluetooth_viewmodel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.plants) { plant in
                    NavigationLink(destination: IndividualPlantView(my_plant: plant).toolbar(.hidden, for: .tabBar)) {
                        HStack {
                            Image(plant.plant_image) // Assumes you have an image named "Flower" in your assets
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 2)
                                .padding(.leading, 10)
                            
                            Text(plant.plant_name)
                                .font(.title3)
                                .padding(.leading, 10)
                            
                            Spacer() // Pushes everything to the left and right edges
                        }
                            .padding() // Add padding to the HStack for spacing
                            .frame(maxWidth: .infinity, alignment: .leading) // Makes the HStack take the full width
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemBackground))) // Adds a white background with rounded corners
                            .shadow(color: .gray, radius: 2, x: 0, y: 1)
                            .padding(.vertical, 5) // Adds padding above and below each row for spacing
                        
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(
                leading: Text("Your Plants")
                    .font(.largeTitle)
                    .fontWeight(.bold),
                trailing: Button(action: {
                    // Action for adding a new plant
                    isShowingCreatePlantView = true
                    print("Add Plant Clicked")
                    
                }) {
                    Image(systemName: "plus")
                }
            ).sheet(isPresented: $isShowingCreatePlantView) {
                CreatePlantView()
                    .environmentObject(viewModel)
            }
            
        }

    }
    
    
    struct PlantView_Previews: PreviewProvider {
        static var previews: some View {
            PlantView()
        }
    }
}

#Preview{
    PlantView()
        .environmentObject(bluetooth_viewmodel())
}


//TODO: JAXONS OLD BUTTON THAT WAS MOVED INTO INDIVIDUAL PLANT VIEW
//                VStack{
//                    ZStack{
//                        HStack (spacing: 0){
//                            NavigationLink(destination: GraphWeek(),
//                                           tag: "More Info", selection: $selectedOption) {
//                                Text("More Info")
//                                    .bold()
//                                    .foregroundColor(.black)
//                                    .padding(8)
//                                    .overlay(RoundedRectangle(cornerRadius: 8)
//                                        .stroke(Color.gray, lineWidth: selectedOption == "More Info" ? 2 : 0))
//                            }.isDetailLink(false)
//                        }
//                        .font(.system(size: 30))
//                    }
//                }
