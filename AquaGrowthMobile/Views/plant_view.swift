import SwiftUI

struct PlantView: View {
    @State private var selectedOption: String? = nil
    @State private var isShowingCreatePlantView = false
    let plants = [
        Plant(plant_name: "Fern", plant_type: "fern", plant_description: "", plant_image: "Flower"),
        Plant(plant_name: "Cactus", plant_type: "cactus", plant_description: "", plant_image: "Flower"),
        Plant(plant_name: "Orchid", plant_type: "orchid", plant_description: "", plant_image: "Flower"),
        Plant(plant_name: "Rose", plant_type: "rose", plant_description: "", plant_image: "Flower")
    ]
    
    var body: some View {
        NavigationView {
            
            List {
                
                ForEach(plants) { plant in
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
                VStack{
                    ZStack{
                        HStack (spacing: 0){
                            NavigationLink(destination: GraphWeek(),
                                           tag: "More Info", selection: $selectedOption) {
                                Text("More Info")
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: selectedOption == "More Info" ? 2 : 0))
                            }.isDetailLink(false)
                        }
                        .font(.system(size: 30))
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
}
