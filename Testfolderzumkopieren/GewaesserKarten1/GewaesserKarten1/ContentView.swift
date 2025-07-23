//
//  ContentView.swift
//  GewaesserKarten1
//
//  Created by Artur Günter on 22.07.25.
//

import SwiftUI
import MapKit



struct Gewaesser: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.77, longitude: 11.15),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    @State private var showNames = true
    @State private var searchText = ""
    @State private var showSearchResults = false
    
    private let startRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.77, longitude: 11.15),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    var filteredGewaesser: [Gewaesser] {
        if searchText.isEmpty {
            return gewaesser
        } else {
            return gewaesser.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: showSearchResults ? filteredGewaesser : gewaesser) { lake in
                MapAnnotation(coordinate: lake.coordinate) {
                    VStack {
                        Image(systemName: "drop.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                        if showNames {
                            Text(lake.name)
                                .font(.caption)
                                .padding(2)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Suchfeld
                HStack {
                    TextField("Gewässer suchen...", text: $searchText, onEditingChanged: { editing in
                        showSearchResults = editing
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 50)
                    .shadow(radius: 5)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            hideKeyboard()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        }
                    }
                }
                
                // Suchvorschläge
                if showSearchResults && !searchText.isEmpty {
                    List(filteredGewaesser) { gewaesser in
                        Button(action: {
                            searchText = gewaesser.name
                            region.center = gewaesser.coordinate
                            region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            showSearchResults = false
                            hideKeyboard()
                        }) {
                            Text(gewaesser.name)
                        }
                    }
                    .frame(height: 200)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                }
                
                Spacer()
                
                // Steuerungsbuttons
                HStack {
                    VStack(spacing: 10) {
                        Button(action: {
                            zoomIn()
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            zoomOut()
                        }) {
                            Image(systemName: "minus")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            withAnimation {
                                region = startRegion
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            withAnimation {
                                showNames.toggle()
                            }
                        }) {
                            Image(systemName: showNames ? "text.bubble.fill" : "text.bubble")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
    
    private func zoomIn() {
        withAnimation {
            region.span.latitudeDelta /= 1.5
            region.span.longitudeDelta /= 1.5
        }
    }
    
    private func zoomOut() {
        withAnimation {
            region.span.latitudeDelta *= 1.5
            region.span.longitudeDelta *= 1.5
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



let gewaesser = [
    Gewaesser(name: "Neddersee", coordinate: CLLocationCoordinate2D(latitude: 53.7033, longitude: 11.0630)),
        Gewaesser(name: "Menzendorfer See", coordinate: CLLocationCoordinate2D(latitude: 53.8436, longitude: 11.0045)),
    Gewaesser(name: "Wedendorfer See", coordinate: CLLocationCoordinate2D(latitude: 53.7689, longitude: 11.1121)),
    Gewaesser(name: "Großeichsener See", coordinate: CLLocationCoordinate2D(latitude: 53.7493, longitude: 11.2607)),
    Gewaesser(name: "Ploggensee", coordinate: CLLocationCoordinate2D(latitude: 53.8674, longitude: 11.1929)),
    Gewaesser(name: "Oberteich (Schönberg)", coordinate: CLLocationCoordinate2D(latitude: 53.8461, longitude: 10.9300)),
    Gewaesser(name: "Großer See (Schlagsdorf)", coordinate: CLLocationCoordinate2D(latitude: 53.7303, longitude: 10.8236)),
    Gewaesser(name: "Kleiner See (Schlagsdorf)", coordinate: CLLocationCoordinate2D(latitude: 53.7304, longitude: 10.8240)),
    Gewaesser(name: "Kiebitzmoor", coordinate: CLLocationCoordinate2D(latitude: 53.8797, longitude: 11.1570)),
    Gewaesser(name: "Burgsee (Gadebusch)", coordinate: CLLocationCoordinate2D(latitude: 53.7020, longitude: 11.1220)),
    Gewaesser(name: "Karpfenteich (Oll Mur)", coordinate: CLLocationCoordinate2D(latitude: 53.8731, longitude: 11.2116)),
    Gewaesser(name: "Lüttsee", coordinate: CLLocationCoordinate2D(latitude: 53.7804, longitude: 11.0504)),
    Gewaesser(name: "Mühlenteich (Rehna)", coordinate: CLLocationCoordinate2D(latitude: 53.7810, longitude: 11.0488)),
    Gewaesser(name: "Mühlenteich (Rüting)", coordinate: CLLocationCoordinate2D(latitude: 53.7925, longitude: 11.2197)),
    Gewaesser(name: "Passbüttel", coordinate: CLLocationCoordinate2D(latitude: 53.7303, longitude: 10.8236)),
    Gewaesser(name: "Neukloster See", coordinate: CLLocationCoordinate2D(latitude: 53.8730, longitude: 11.7000)),
    Gewaesser(name: "Wariner See", coordinate: CLLocationCoordinate2D(latitude: 53.7830, longitude: 11.6330)),
    Gewaesser(name: "Bibower See", coordinate: CLLocationCoordinate2D(latitude: 53.7540, longitude: 11.6110)),
    Gewaesser(name: "Tressower See", coordinate: CLLocationCoordinate2D(latitude: 53.8810, longitude: 11.2270)),
    Gewaesser(name: "Glammsee", coordinate: CLLocationCoordinate2D(latitude: 53.7840, longitude: 11.6880)),
    Gewaesser(name: "Ventschower See", coordinate: CLLocationCoordinate2D(latitude: 53.7870, longitude: 11.5160)),
    Gewaesser(name: "Tarzower See", coordinate: CLLocationCoordinate2D(latitude: 53.8660, longitude: 11.1630)),
    Gewaesser(name: "Ravensruher See", coordinate: CLLocationCoordinate2D(latitude: 53.7870, longitude: 11.5160)),
    Gewaesser(name: "Karpfenteich Groß Stieten", coordinate: CLLocationCoordinate2D(latitude: 53.8200, longitude: 11.4800)),
    Gewaesser(name: "Priestersee", coordinate: CLLocationCoordinate2D(latitude: 53.8650, longitude: 11.3940)),
    Gewaesser(name: "Teich am Zierower Weg", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 11.4500)),
    Gewaesser(name: "Schmiedeteich Maßlow", coordinate: CLLocationCoordinate2D(latitude: 53.8320, longitude: 11.5070)),
    Gewaesser(name: "Hellensee Schimm", coordinate: CLLocationCoordinate2D(latitude: 53.7960, longitude: 11.5130)),
    Gewaesser(name: "Kuhldiek Goldebee", coordinate: CLLocationCoordinate2D(latitude: 53.8490, longitude: 11.5890)),
    Gewaesser(name: "Stau am Graben Neu Farpen", coordinate: CLLocationCoordinate2D(latitude: 53.9630, longitude: 11.5370)),
    Gewaesser(name: "Gärtnerteiche Wismar", coordinate: CLLocationCoordinate2D(latitude: 53.8880, longitude: 11.4530)),
    Gewaesser(name: "Rethteich Schmakentin", coordinate: CLLocationCoordinate2D(latitude: 53.8970, longitude: 11.3740)),
    Gewaesser(name: "Waldteich Rambow", coordinate: CLLocationCoordinate2D(latitude: 53.8480, longitude: 11.3060)),
    Gewaesser(name: "Ziegeleiteich an der Köppernitz", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 11.4500)),
    Gewaesser(name: "Teich hinterm Wendenkrug", coordinate: CLLocationCoordinate2D(latitude: 53.8850, longitude: 11.4600)),
    Gewaesser(name: "Lenensruher Teich", coordinate: CLLocationCoordinate2D(latitude: 53.8800, longitude: 11.4200)),
    // Landkreis Lüneburg / RAV Süd-West-Mecklenburg
        Gewaesser(name: "Tönniesbach", coordinate: CLLocationCoordinate2D(latitude: 53.7790, longitude: 11.6910)),
        Gewaesser(name: "Sumter See (Mittelteil)", coordinate: CLLocationCoordinate2D(latitude: 53.1910, longitude: 10.8700)),
        Gewaesser(name: "See Motel (Krainkesee)", coordinate: CLLocationCoordinate2D(latitude: 53.1930, longitude: 10.8500)),
        Gewaesser(name: "See Haarer Brücke (Krainkesee)", coordinate: CLLocationCoordinate2D(latitude: 53.1925, longitude: 10.8480)),
        Gewaesser(name: "Alte Tonkuhlen", coordinate: CLLocationCoordinate2D(latitude: 53.1940, longitude: 10.8650)),
        Gewaesser(name: "Mahlbusen Sückau Ost", coordinate: CLLocationCoordinate2D(latitude: 53.2240, longitude: 10.8500)),

        // Landkreis Ludwigslust-Parchim / RAV Süd-West-Mecklenburg
        Gewaesser(name: "Woezer See (südwestlicher Teil)", coordinate: CLLocationCoordinate2D(latitude: 53.4880, longitude: 11.0420)),
        Gewaesser(name: "Probst Jesarer See", coordinate: CLLocationCoordinate2D(latitude: 53.2980, longitude: 11.0910)),
        Gewaesser(name: "Burgsee Besitz", coordinate: CLLocationCoordinate2D(latitude: 53.3600, longitude: 10.8380)),
        Gewaesser(name: "Fischkuhle 1 Püttelkow", coordinate: CLLocationCoordinate2D(latitude: 53.4230, longitude: 11.0280)),
        Gewaesser(name: "Nordische Kuhle Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4250, longitude: 11.1900)),
        Gewaesser(name: "Laakenkuhle Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4255, longitude: 11.1925)),
        Gewaesser(name: "Große Kuhle Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4260, longitude: 11.1950)),
        Gewaesser(name: "Kuhlen am Wasserturm Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4280, longitude: 11.1980)),
        Gewaesser(name: "Kiessee Neu Zachun", coordinate: CLLocationCoordinate2D(latitude: 53.4490, longitude: 11.2330)),
        Gewaesser(name: "Altendorfer Teich Boizenburg", coordinate: CLLocationCoordinate2D(latitude: 53.3880, longitude: 10.7210)),
        Gewaesser(name: "Baggersee Gülze", coordinate: CLLocationCoordinate2D(latitude: 53.3730, longitude: 10.8960)),
        Gewaesser(name: "Torfkuhle Boddin Püttelkow", coordinate: CLLocationCoordinate2D(latitude: 53.4210, longitude: 11.0260)),
        Gewaesser(name: "Schleienkuhle Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4265, longitude: 11.1970)),
        Gewaesser(name: "Brack bei Cafe Kiss Groß Timkenberg", coordinate: CLLocationCoordinate2D(latitude: 53.4480, longitude: 10.9010)),
        Gewaesser(name: "Badeanstalt Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4285, longitude: 11.1935)),
        Gewaesser(name: "Mühlenbrack Bandekow", coordinate: CLLocationCoordinate2D(latitude: 53.4260, longitude: 11.0120)),
        Gewaesser(name: "Mühlenteich Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4280, longitude: 11.1955)),
        Gewaesser(name: "Sedimentfang Hagenow", coordinate: CLLocationCoordinate2D(latitude: 53.4290, longitude: 11.1960)),
    
        // Fließgewässer
        Gewaesser(name: "Sude-Krainke Mankenwerder", coordinate: CLLocationCoordinate2D(latitude: 53.3910, longitude: 10.7130)),
        Gewaesser(name: "Sude Boizenburg", coordinate: CLLocationCoordinate2D(latitude: 53.3810, longitude: 10.7080)),
        Gewaesser(name: "Krainke Besitz/Preten", coordinate: CLLocationCoordinate2D(latitude: 53.3180, longitude: 10.8220)),
        Gewaesser(name: "Schilde", coordinate: CLLocationCoordinate2D(latitude: 53.5040, longitude: 11.0520)),
        Gewaesser(name: "Motel", coordinate: CLLocationCoordinate2D(latitude: 53.5090, longitude: 11.0790)),
        Gewaesser(name: "Brückenkanal Horst", coordinate: CLLocationCoordinate2D(latitude: 53.3900, longitude: 10.7010)),
        Gewaesser(name: "Kraaker Mühlenbach", coordinate: CLLocationCoordinate2D(latitude: 53.4390, longitude: 11.2120)),
        Gewaesser(name: "Klüßer Mühlenbach", coordinate: CLLocationCoordinate2D(latitude: 53.4370, longitude: 11.1620)),
        Gewaesser(name: "Brahlstorfer Bach", coordinate: CLLocationCoordinate2D(latitude: 53.4170, longitude: 10.9000)),
        Gewaesser(name: "Schmaar", coordinate: CLLocationCoordinate2D(latitude: 53.4460, longitude: 11.0620)),
        Gewaesser(name: "Mühlenbach Schwanheide", coordinate: CLLocationCoordinate2D(latitude: 53.4020, longitude: 10.6790)),
        Gewaesser(name: "Lübtheener Bach", coordinate: CLLocationCoordinate2D(latitude: 53.3090, longitude: 11.0900)),
        Gewaesser(name: "Kleine Sude", coordinate: CLLocationCoordinate2D(latitude: 53.3480, longitude: 10.8600)),
        Gewaesser(name: "Rotenfurt", coordinate: CLLocationCoordinate2D(latitude: 53.3730, longitude: 10.8940)),
        Gewaesser(name: "Simmergraben", coordinate: CLLocationCoordinate2D(latitude: 53.3180, longitude: 10.8500)),
        Gewaesser(name: "Sude Freilauf Brömsenberg", coordinate: CLLocationCoordinate2D(latitude: 53.3520, longitude: 10.7900)),
        Gewaesser(name: "Strohkirchener Bach", coordinate: CLLocationCoordinate2D(latitude: 53.4470, longitude: 11.1930)),
        Gewaesser(name: "Wallgraben und Schacksgraben Boizenburg", coordinate: CLLocationCoordinate2D(latitude: 53.3850, longitude: 10.7060)),
        Gewaesser(name: "Boize und Alte Boize", coordinate: CLLocationCoordinate2D(latitude: 53.5560, longitude: 10.9250)),

        // Stillgewässer
        Gewaesser(name: "Dreenkrögener Badesee", coordinate: CLLocationCoordinate2D(latitude: 53.4120, longitude: 11.5620)),
        Gewaesser(name: "Gänsehals", coordinate: CLLocationCoordinate2D(latitude: 53.3800, longitude: 11.5960)),
        Gewaesser(name: "Eldekuhle am Heiddorfer Deich", coordinate: CLLocationCoordinate2D(latitude: 53.1380, longitude: 11.2630)),
        Gewaesser(name: "Eldekuhle 1 am Kalißer Deich", coordinate: CLLocationCoordinate2D(latitude: 53.1360, longitude: 11.2720)),
        Gewaesser(name: "Lange Eldekuhle", coordinate: CLLocationCoordinate2D(latitude: 53.1370, longitude: 11.2670)),
        Gewaesser(name: "Eldekuhle 2 am Kalißer Deich", coordinate: CLLocationCoordinate2D(latitude: 53.1350, longitude: 11.2740)),
        Gewaesser(name: "Eldekuhle Umleitung", coordinate: CLLocationCoordinate2D(latitude: 53.1320, longitude: 11.2700)),
        Gewaesser(name: "Eldekuhle Bootshafen", coordinate: CLLocationCoordinate2D(latitude: 53.1300, longitude: 11.2750)),
        Gewaesser(name: "Alte Elde am Mühlenteich", coordinate: CLLocationCoordinate2D(latitude: 53.1270, longitude: 11.2760)),
        Gewaesser(name: "Schmölener Brack", coordinate: CLLocationCoordinate2D(latitude: 53.1230, longitude: 11.2830)),
        Gewaesser(name: "Ochsenbrack", coordinate: CLLocationCoordinate2D(latitude: 53.1220, longitude: 11.2840)),
        Gewaesser(name: "Herrensee Dömitz", coordinate: CLLocationCoordinate2D(latitude: 53.1260, longitude: 11.2790)),
        Gewaesser(name: "Mahlbusen Dömitz", coordinate: CLLocationCoordinate2D(latitude: 53.1250, longitude: 11.2810)),

        // Weitere Fließgewässer
        Gewaesser(name: "Rögnitz bei Gudow", coordinate: CLLocationCoordinate2D(latitude: 53.5180, longitude: 10.8460)),
        Gewaesser(name: "Alte Elde Hohewisch", coordinate: CLLocationCoordinate2D(latitude: 53.3350, longitude: 11.5630)),
        Gewaesser(name: "Alte Elde Grabow-Güritz", coordinate: CLLocationCoordinate2D(latitude: 53.2760, longitude: 11.5400)),
        Gewaesser(name: "Elde-Rögnitz-Überleiter", coordinate: CLLocationCoordinate2D(latitude: 53.3350, longitude: 11.2700)),
        Gewaesser(name: "Müritz-Elde-Wasserstraße", coordinate: CLLocationCoordinate2D(latitude: 53.1530, longitude: 11.2410)),
        Gewaesser(name: "Fleetgraben Dömitz", coordinate: CLLocationCoordinate2D(latitude: 53.1265, longitude: 11.2780)),
        Gewaesser(name: "Turmgraben Neustadt-Glewe", coordinate: CLLocationCoordinate2D(latitude: 53.3790, longitude: 11.5940)),
        Gewaesser(name: "Brenzer Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.3730, longitude: 11.5230)),
        Gewaesser(name: "Drellengraben", coordinate: CLLocationCoordinate2D(latitude: 53.3910, longitude: 11.5860)),
        Gewaesser(name: "Elbe Dömitz", coordinate: CLLocationCoordinate2D(latitude: 53.1380, longitude: 11.2780)),
        Gewaesser(name: "Löcknitz Polz-Rüterberg", coordinate: CLLocationCoordinate2D(latitude: 53.2170, longitude: 11.3480)),
        Gewaesser(name: "Ludwigsluster Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.3300, longitude: 11.5000)),
        Gewaesser(name: "Löcknitz Quelle", coordinate: CLLocationCoordinate2D(latitude: 53.3130, longitude: 11.2150)),
        Gewaesser(name: "Meynbach", coordinate: CLLocationCoordinate2D(latitude: 53.2780, longitude: 11.5080)),
        Gewaesser(name: "Karpfenteichgraben Neustadt-Glewe", coordinate: CLLocationCoordinate2D(latitude: 53.3760, longitude: 11.5990)),
        Gewaesser(name: "Alte Elde Neu Kaliß", coordinate: CLLocationCoordinate2D(latitude: 53.1580, longitude: 11.3130)),
    
        Gewaesser(name: "Dümmer See", coordinate: CLLocationCoordinate2D(latitude: 53.2280, longitude: 11.9120)),
        Gewaesser(name: "Settiner See", coordinate: CLLocationCoordinate2D(latitude: 53.4870, longitude: 11.4530)),
        Gewaesser(name: "Crivitzer See", coordinate: CLLocationCoordinate2D(latitude: 53.5370, longitude: 11.4610)),
        Gewaesser(name: "Glambecksee", coordinate: CLLocationCoordinate2D(latitude: 53.5560, longitude: 11.4580)),
        Gewaesser(name: "Militzsee", coordinate: CLLocationCoordinate2D(latitude: 53.5270, longitude: 11.4610)),
        Gewaesser(name: "Vorbecker See", coordinate: CLLocationCoordinate2D(latitude: 53.5060, longitude: 11.4940)),
        Gewaesser(name: "Pragsee (Schwarzer See)", coordinate: CLLocationCoordinate2D(latitude: 53.5470, longitude: 11.5300)),
        Gewaesser(name: "Dorfsee Demen", coordinate: CLLocationCoordinate2D(latitude: 53.4800, longitude: 11.7130)),
        Gewaesser(name: "Fauler See", coordinate: CLLocationCoordinate2D(latitude: 53.4820, longitude: 11.7160)),
        Gewaesser(name: "Tiefer See", coordinate: CLLocationCoordinate2D(latitude: 53.4830, longitude: 11.7170)),
        Gewaesser(name: "Kraaker Kiessee", coordinate: CLLocationCoordinate2D(latitude: 53.5230, longitude: 11.7290)),
        Gewaesser(name: "Kritzower See (Hofsee)", coordinate: CLLocationCoordinate2D(latitude: 53.5660, longitude: 11.7430)),
        Gewaesser(name: "Frauensee Basthorst", coordinate: CLLocationCoordinate2D(latitude: 53.5730, longitude: 11.7550)),
        Gewaesser(name: "Langsee Gneven", coordinate: CLLocationCoordinate2D(latitude: 53.5580, longitude: 11.4280)),
        Gewaesser(name: "Krebssee Gneven", coordinate: CLLocationCoordinate2D(latitude: 53.5590, longitude: 11.4300)),
        Gewaesser(name: "Barschkuhle Demen", coordinate: CLLocationCoordinate2D(latitude: 53.4810, longitude: 11.7110)),
        Gewaesser(name: "Schwarzer See Rubow", coordinate: CLLocationCoordinate2D(latitude: 53.6030, longitude: 11.5770)),
        Gewaesser(name: "Poschmannsteich Rubow", coordinate: CLLocationCoordinate2D(latitude: 53.6050, longitude: 11.5780)),
        Gewaesser(name: "Hundsbecken Rubow", coordinate: CLLocationCoordinate2D(latitude: 53.6055, longitude: 11.5790)),
        Gewaesser(name: "Ochsenkoppelteich Rubow", coordinate: CLLocationCoordinate2D(latitude: 53.6058, longitude: 11.5800)),
        Gewaesser(name: "Muchelwitzer See Gädebehn", coordinate: CLLocationCoordinate2D(latitude: 53.5280, longitude: 11.6570)),
        Gewaesser(name: "Dorfteich Zapel", coordinate: CLLocationCoordinate2D(latitude: 53.5300, longitude: 11.6490)),
        Gewaesser(name: "Baggerteich Crivitz", coordinate: CLLocationCoordinate2D(latitude: 53.5360, longitude: 11.4660)),
        Gewaesser(name: "Mühlengraben Banzkow", coordinate: CLLocationCoordinate2D(latitude: 53.6270, longitude: 11.4210)),
        Gewaesser(name: "Störkanal", coordinate: CLLocationCoordinate2D(latitude: 53.6200, longitude: 11.3800)),
        Gewaesser(name: "Warnow bei Crivitz-Brüel", coordinate: CLLocationCoordinate2D(latitude: 53.5700, longitude: 11.4300)),
        Gewaesser(name: "Warnow bei Müsselmow", coordinate: CLLocationCoordinate2D(latitude: 53.4930, longitude: 11.4500)),
        Gewaesser(name: "Banzkower Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.6280, longitude: 11.4200)),
        Gewaesser(name: "Aubach (Klein Medewege)", coordinate: CLLocationCoordinate2D(latitude: 53.6100, longitude: 11.4670)),
        Gewaesser(name: "Crivitzer Bach (Amtsbach)", coordinate: CLLocationCoordinate2D(latitude: 53.5400, longitude: 11.4600)),
        Gewaesser(name: "Demener Bach", coordinate: CLLocationCoordinate2D(latitude: 53.4770, longitude: 11.7100)),
        Gewaesser(name: "Langer Moorgraben (Alte Warnow)", coordinate: CLLocationCoordinate2D(latitude: 53.4750, longitude: 11.7080)),
    Gewaesser(name: "Goldberger See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0833)),
        Gewaesser(name: "Dobbertiner See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0833)),
        Gewaesser(name: "Damerower See", coordinate: CLLocationCoordinate2D(latitude: 53.5040, longitude: 12.1130)),
        Gewaesser(name: "Garder See", coordinate: CLLocationCoordinate2D(latitude: 53.3550, longitude: 11.8300)),
        Gewaesser(name: "Treptowsee", coordinate: CLLocationCoordinate2D(latitude: 53.4270, longitude: 11.9220)),
        Gewaesser(name: "Wockersee", coordinate: CLLocationCoordinate2D(latitude: 53.4200, longitude: 11.8450)),
        Gewaesser(name: "Langhagensee", coordinate: CLLocationCoordinate2D(latitude: 53.4680, longitude: 11.8460)),
        Gewaesser(name: "Weisiner See", coordinate: CLLocationCoordinate2D(latitude: 53.4090, longitude: 11.8010)),
        Gewaesser(name: "Schalentiner See", coordinate: CLLocationCoordinate2D(latitude: 53.4170, longitude: 11.7850)),
        Gewaesser(name: "Daschower See", coordinate: CLLocationCoordinate2D(latitude: 53.4010, longitude: 11.7990)),
        Gewaesser(name: "Diestelower See", coordinate: CLLocationCoordinate2D(latitude: 53.3530, longitude: 11.7740)),
        Gewaesser(name: "Unterer Voigtsdorfer Teich", coordinate: CLLocationCoordinate2D(latitude: 53.4100, longitude: 11.7430)),
        Gewaesser(name: "Klinkener See", coordinate: CLLocationCoordinate2D(latitude: 53.3900, longitude: 11.6960)),
    Gewaesser(name: "Unteruckersee", coordinate: CLLocationCoordinate2D(latitude: 53.2000, longitude: 13.9167)),
        Gewaesser(name: "Oberer Voigtsdorfer Teich", coordinate: CLLocationCoordinate2D(latitude: 53.4110, longitude: 11.7450)),
        Gewaesser(name: "Kleines Moor Kossebade", coordinate: CLLocationCoordinate2D(latitude: 53.3900, longitude: 11.7890)),
        Gewaesser(name: "Dorfteich Kiekindemark", coordinate: CLLocationCoordinate2D(latitude: 53.3970, longitude: 11.8210)),
        Gewaesser(name: "Lang in Söw Ruthen", coordinate: CLLocationCoordinate2D(latitude: 53.4420, longitude: 11.8400)),
        Gewaesser(name: "Slater Moor und Eldealtarm", coordinate: CLLocationCoordinate2D(latitude: 53.4250, longitude: 11.8500)),
        Gewaesser(name: "Karpfenteich Groß Pankow", coordinate: CLLocationCoordinate2D(latitude: 53.4450, longitude: 11.9200)),
        Gewaesser(name: "Kiessee Raduhn", coordinate: CLLocationCoordinate2D(latitude: 53.4040, longitude: 11.7000)),
        Gewaesser(name: "Oberer Herrenteich Parchim", coordinate: CLLocationCoordinate2D(latitude: 53.3930, longitude: 11.8180)),
    
        // Oberer Herrenteich Parchim
        Gewaesser(name: "Oberer Herrenteich", coordinate: CLLocationCoordinate2D(latitude: 53.4269, longitude: 11.8486)),
        
        // Warnow
        Gewaesser(name: "Warnow (Woeten bis Barniner See)", coordinate: CLLocationCoordinate2D(latitude: 53.5400, longitude: 11.7200)),
    Gewaesser(name: "Warnow", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.9167)),
        
        // Mildenitz
        Gewaesser(name: "Mildenitz (Wendisch-Waren bis Goldberger See)", coordinate: CLLocationCoordinate2D(latitude: 53.5200, longitude: 12.1300)),
        Gewaesser(name: "Mildenitz (Goldberger See bis Dobbertiner See)", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 12.0500)),
        
        // Altarm der Elde
        Gewaesser(name: "Altarm der Elde bei Burow", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 11.9500)),
        
        // Alte Elde
        Gewaesser(name: "Alte Elde (Freischleuse in Damm bis Matzlow/Garwitz)", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 11.7833)),
        Gewaesser(name: "Alte Elde (Burow/Siggelkow bis Neuburg)", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 11.9000)),
        
        // Gehlsbach
        Gewaesser(name: "Gehlsbach (Retzow)", coordinate: CLLocationCoordinate2D(latitude: 53.4833, longitude: 11.8833)),
        Gewaesser(name: "Gehlsbach (Ganzlin bis Twietfort)", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 11.9333)),
        
        // Grenzgraben
        Gewaesser(name: "Grenzgraben (Wooster See bis B192)", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.1167)),
        
        // Klinkener Bach
        Gewaesser(name: "Klinkener Bach", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 11.6833)),
        
        // Basnitzbach
        Gewaesser(name: "Basnitzbach", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 11.9167)),
        
        // Mooster Bach
        Gewaesser(name: "Mooster Bach", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 11.9333)),
    Gewaesser(name: "Müritz", coordinate: CLLocationCoordinate2D(latitude: 53.4167, longitude: 12.6833)),
        
        // Müritz-Elde-Wasserstraße
        Gewaesser(name: "Müritz-Elde-Wasserstraße", coordinate: CLLocationCoordinate2D(latitude: 53.4583, longitude: 12.2625)),
        
        // Wocker
        Gewaesser(name: "Wocker", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 11.4500)),
        
        // Sternberger See
        Gewaesser(name: "Sternberger See", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.8167)),
        
        // Kleinpritzer See
        Gewaesser(name: "Kleinpritzer See", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 11.9000)),
        
        // Woseriner See
        Gewaesser(name: "Woseriner See", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 11.9333)),
        
        // Tempziner See
        Gewaesser(name: "Tempziner See", coordinate: CLLocationCoordinate2D(latitude: 53.7667, longitude: 11.6833)),
        
        // Keezer See
        Gewaesser(name: "Keezer See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 11.6167)),
        
        // Trenntsee
        Gewaesser(name: "Trenntsee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.8833)),
        
        // Neuhofer See
        Gewaesser(name: "Neuhofer See", coordinate: CLLocationCoordinate2D(latitude: 53.7500, longitude: 11.9333)),
        
        // Holzendorfer See
        Gewaesser(name: "Holzendorfer See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.7000)),
        
        // Luckower See
        Gewaesser(name: "Luckower See", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.8333)),
        
        // Dabeler See
        Gewaesser(name: "Dabeler See", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 11.9000)),
        
        // Groß Radener See
        Gewaesser(name: "Groß Radener See", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.8833)),
        
        // Großer Steedersee
        Gewaesser(name: "Großer Steedersee", coordinate: CLLocationCoordinate2D(latitude: 53.7667, longitude: 11.6833)),
        
        // Schönlager See
        Gewaesser(name: "Schönlager See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.7000)),
        
        // Deichelsee
        Gewaesser(name: "Deichelsee", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Entensee
        Gewaesser(name: "Entensee", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 11.9500)),
        
        // Glammsee
        Gewaesser(name: "Glammsee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Hohlsee
        Gewaesser(name: "Hohlsee", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Roter See
        Gewaesser(name: "Roter See", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Heidensee
        Gewaesser(name: "Heidensee Müsselmow", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.5667)),
        
        // Hilkensee
        Gewaesser(name: "Hilkensee", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Sandsee
        Gewaesser(name: "Sandsee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Biber See (Dinniesensee)
        Gewaesser(name: "Biber See", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Sydowsee
        Gewaesser(name: "Sydowsee", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.5667)),
        
        // Viersee
        Gewaesser(name: "Viersee", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.5667)),
        
        // Rothsee (Parksee)
        Gewaesser(name: "Rothsee", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.5667)),
        
        // Mühlensee
        Gewaesser(name: "Mühlensee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Glockensee (Pfaffensee)
        Gewaesser(name: "Glockensee", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Stüwickssee
        Gewaesser(name: "Stüwickssee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Fiedlersee
        Gewaesser(name: "Fiedlersee", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 11.9500)),
        
        // Plumer See
        Gewaesser(name: "Plumer See", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Kreuzsee
        Gewaesser(name: "Kreuzsee", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Wispelmoor
        Gewaesser(name: "Wispelmoor", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 11.7167)),
        
        // Ortmannsee
        Gewaesser(name: "Ortmannsee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Waukuhlsee
        Gewaesser(name: "Waukuhlsee", coordinate: CLLocationCoordinate2D(latitude: 53.7167, longitude: 11.9333)),
        
        // Poggenhöfer Moor
        Gewaesser(name: "Poggenhöfer Moor", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.5667)),
        
        // Schleiloch
        Gewaesser(name: "Schleiloch", coordinate: CLLocationCoordinate2D(latitude: 53.8000, longitude: 11.5667)),
        
        // Schweriner Innensee
        Gewaesser(name: "Schweriner Innensee", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.4167)),
        
        // Schweriner Außensee
        Gewaesser(name: "Schweriner Außensee", coordinate: CLLocationCoordinate2D(latitude: 53.6500, longitude: 11.4500)),
        
        // Ziegelinnen- und Außensee
        Gewaesser(name: "Ziegelsee", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.4167)),
        
        // Neumühler See
        Gewaesser(name: "Neumühler See", coordinate: CLLocationCoordinate2D(latitude: 53.6000, longitude: 11.3667)),
        
        // Medeweger See
        Gewaesser(name: "Medeweger See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.3833)),
        
        // Lankower See
        Gewaesser(name: "Lankower See", coordinate: CLLocationCoordinate2D(latitude: 53.6500, longitude: 11.3667)),
        
        // Fauler See
        Gewaesser(name: "Fauler See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.4167)),
        
        // Heidensee Schwerin
        Gewaesser(name: "Heidensee Schwerin", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.4167)),
    Gewaesser(name: "Schweriner See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.4167)),
        
        // Burgsee
        Gewaesser(name: "Burgsee", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 11.4167)),
        
        // Sildemower See
        Gewaesser(name: "Sildemower See", coordinate: CLLocationCoordinate2D(latitude: 53.9667, longitude: 12.1000)),
        
        // Kiesgrube Rostock-Riedahl
        Gewaesser(name: "Kiesgrube Rostock-Riedahl", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 12.1333)),
        
        // Schwanenteich Rostock
        Gewaesser(name: "Schwanenteich Rostock", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 12.1333)),
        
        // Staugewässer (Mühlenteich) Rostock-Toitenwinkel
        Gewaesser(name: "Mühlenteich Toitenwinkel", coordinate: CLLocationCoordinate2D(latitude: 54.1167, longitude: 12.2333)),
        
        // Mühlenteich Rostock-Evershagen
        Gewaesser(name: "Mühlenteich Evershagen", coordinate: CLLocationCoordinate2D(latitude: 54.1333, longitude: 12.0500)),
        
        // Vietower See
        Gewaesser(name: "Vietower See", coordinate: CLLocationCoordinate2D(latitude: 53.9167, longitude: 12.4667)),
        
        // Stassower See
        Gewaesser(name: "Stassower See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4333)),
        
        // Satower See
        Gewaesser(name: "Satower See", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 11.8833)),
        
        // Boocksee
        Gewaesser(name: "Boocksee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4667)),
        
        // Hofsee
        Gewaesser(name: "Hofsee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4667)),
        
        // Teich bei Liessow
        Gewaesser(name: "Teich bei Liessow", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4667)),
        
        // Groß Lüsewitzer See
        Gewaesser(name: "Groß Lüsewitzer See", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 12.3333)),
        
        // Horster See
        Gewaesser(name: "Horster See", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 12.2333)),
        
        // Krebssee
        Gewaesser(name: "Krebssee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4667)),
        
        // Langer See
        Gewaesser(name: "Langer See", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 12.2333)),
        
        // Torfstich Papendorf
        Gewaesser(name: "Torfstich Papendorf", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 12.1333)),
        
        // Dorfteich Bliesekow
        Gewaesser(name: "Dorfteich Bliesekow", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 12.4667)),
        
        // Lütt See
        Gewaesser(name: "Lütt See", coordinate: CLLocationCoordinate2D(latitude: 53.9167, longitude: 12.4667)),
        
        // Steinkiste / Schwanenteich
        Gewaesser(name: "Steinkiste / Schwanenteich", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 11.9667)),
        
        // Suchsmoor
        Gewaesser(name: "Suchsmoor", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 11.9667)),
        
        // Karpfenteich Kühlungsborn
        Gewaesser(name: "Karpfenteich Kühlungsborn", coordinate: CLLocationCoordinate2D(latitude: 54.1333, longitude: 11.7667)),
        
        // Meyersloch
        Gewaesser(name: "Meyersloch", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 12.2000)),
        
        // Torfkuhlen Kessin
        Gewaesser(name: "Torfkuhlen Kessin", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 12.1833)),
        
        // Entenmoor
        Gewaesser(name: "Entenmoor", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 12.2333)),
        
        // Ton- und Kiesgruben Papendorf
        Gewaesser(name: "Ton- und Kiesgruben Papendorf", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 12.1333)),
        
        // Stromgraben (Mahlbusen)
        Gewaesser(name: "Stromgraben Graal-Müritz", coordinate: CLLocationCoordinate2D(latitude: 54.2500, longitude: 12.2500)),
        
        // Hohendiek
        Gewaesser(name: "Hohendiek", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 11.8833)),
        
        // Dorfteich Hanstorf
        Gewaesser(name: "Dorfteich Hanstorf", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 11.9667)),
        
        // Schiffswiesen
        Gewaesser(name: "Schiffswiesen", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 11.8833)),
        
        // Hanstorfer Moor
        Gewaesser(name: "Hanstorfer Moor", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 11.9667)),
        
        // Torfkuhle an der Bahn
        Gewaesser(name: "Torfkuhle an der Bahn", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 12.1833)),
        
        // Kapellenteich
        Gewaesser(name: "Kapellenteich", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 12.1833)),
        
        // Torfmoor Moitin
        Gewaesser(name: "Torfmoor Moitin", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 12.2333)),
        
        // Potteich
        Gewaesser(name: "Potteich", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.2000)),
        
        // Ton- und Badekuhle
        Gewaesser(name: "Ton- und Badekuhle", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.2000)),
        
        // Teich alte Kiesgrube
        Gewaesser(name: "Teich alte Kiesgrube", coordinate: CLLocationCoordinate2D(latitude: 54.0667, longitude: 11.8000)),
        
        // Hellbach
        Gewaesser(name: "Hellbach", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 11.6667)),
    
    
        Gewaesser(name: "Recknitz (Liessow bis Liepen/Dudendorf)", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4667)),
        Gewaesser(name: "Conventer Randkanal / Mühlenfließ", coordinate: CLLocationCoordinate2D(latitude: 54.1000, longitude: 11.9000)),
        Gewaesser(name: "Fulgenbach", coordinate: CLLocationCoordinate2D(latitude: 54.1333, longitude: 11.7667)),
        Gewaesser(name: "Stromstorfer Bach", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.4667)),
        Gewaesser(name: "Zarnow", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.1000)),
        Gewaesser(name: "Panzower Bach", coordinate: CLLocationCoordinate2D(latitude: 54.0333, longitude: 11.6667)),
        Gewaesser(name: "Kanal Schwaan", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.1000)),
        Gewaesser(name: "Langer See Bützow", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Langesee (Langer See) Rosenow", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0333)),
        Gewaesser(name: "Boitiner See", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 11.8833)),
        Gewaesser(name: "Priestersee", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0333)),
        Gewaesser(name: "Lübziner See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0333)),
        Gewaesser(name: "Triensee", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Sülzpfuhl", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 11.9333)),
        Gewaesser(name: "Schwaaner Moor (Teilstück)", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.1000)),
        Gewaesser(name: "Zerniner See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0333)),
        Gewaesser(name: "Torfloch Warnow", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Schwarzer See Wolken", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.0333)),
        Gewaesser(name: "Papensee (Eilerssee)", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 11.8833)),
        Gewaesser(name: "Tarnower Torfstich", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Karpfenteich Bützow", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Kleine Grubenburg", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.1000)),
        Gewaesser(name: "Stadtmoor Bützow", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Viersee Bützow", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Senketeich", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 12.1000)),
        Gewaesser(name: "Warnow (Bützow)", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 11.9833)),
        Gewaesser(name: "Beke", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 11.8833)),
        Gewaesser(name: "Beke Oberlauf (Seebach)", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 11.8833)),
        Gewaesser(name: "Bützow-Güstrow-Kanal (Nebelkanal)", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 12.0167)),
        Gewaesser(name: "Krakower Untersee", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.2667)),
        Gewaesser(name: "Inselsee und Inselseekanal", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Parumer See", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.1333)),
        Gewaesser(name: "Sumpfsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Radener See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Warinsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Langsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Dolgener See", coordinate: CLLocationCoordinate2D(latitude: 53.9500, longitude: 12.5500)),
        Gewaesser(name: "Bossower See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.2667)),
        Gewaesser(name: "Orthsee", coordinate: CLLocationCoordinate2D(latitude: 53.6167, longitude: 12.4333)),
        Gewaesser(name: "Krummer See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Tiefer Ziest", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Flacher Ziest", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Hofsee Vietgest", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Alter Dorfsee", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.2667)),
        Gewaesser(name: "Dudinghausener See", coordinate: CLLocationCoordinate2D(latitude: 53.9500, longitude: 12.1000)),
        Gewaesser(name: "Krebssee Gülzow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Karower See", coordinate: CLLocationCoordinate2D(latitude: 53.6333, longitude: 12.2667)),
        Gewaesser(name: "Krebssee (Kreftsee)", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 12.4333)),
        Gewaesser(name: "Hofsee Gremmelin", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Großer Mellsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Libowsee", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.2833)),
        Gewaesser(name: "Grimmsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Krassower See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Kleiner Mellsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Swinegel", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Wendorfer See (Garner See)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Gliner See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Kirch Rosiner See", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.2833)),
        Gewaesser(name: "Wilsener See", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 12.4333)),
        Gewaesser(name: "Wüstenmarker See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Kleiner See Liepen", coordinate: CLLocationCoordinate2D(latitude: 53.6167, longitude: 12.4333)),
        Gewaesser(name: "Bauersee", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 12.1000)),
        Gewaesser(name: "Kuhlsee (Kuhsee)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Bolzsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Schumpfsee, Kanal, Pfaffenteich, Breiter Graben", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Torflöcher Klueß", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.2833)),
        Gewaesser(name: "Schwarzer See Koppelow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Torflöcher Lüssow", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 12.1000)),
        Gewaesser(name: "Krebssee Koppelow", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.2833)),
        Gewaesser(name: "Tolziner See (Garner See)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Linstower See", coordinate: CLLocationCoordinate2D(latitude: 53.6167, longitude: 12.3667)),
        Gewaesser(name: "Langhagener See", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 12.4333)),
        Gewaesser(name: "Tiefer See Gremmelin", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Torfloch Striggow", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.2833)),
        Gewaesser(name: "Schmittscher Teich", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Nebel", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Lößnitz (Aalbach)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
        Gewaesser(name: "Bollbäck", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.1667)),
    
        Gewaesser(name: "Teterower See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Großer Neu Heinder See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Wotrumer See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Schillersee", coordinate: CLLocationCoordinate2D(latitude: 53.7500, longitude: 12.3833)),
        Gewaesser(name: "Pannekower See", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 12.7333)),
        Gewaesser(name: "Duckwitzer See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Altkalener See (Pfarrsee)", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 12.7333)),
        Gewaesser(name: "Granzower See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Kleiner See (Lüttsee)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Großer Glasowsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Dorfsee Grambzow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Großen Luckower See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Matgendorfer See (Wall)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Hechtsee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Hütter See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Wothmannsteich", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Dorfteich Quitzenow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Schloßteich Bobbin", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Dorfteich Bobbin", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Dorfteich Wasdow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Dorfteich Dölitz", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Kleiner Glasower See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Großes Torfloch Wasdow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Torfstich Böhmer", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Runder See", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Torfstich Möller", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Torfstich Awolin", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Torstich Vier Pfähle", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Kraftsteckermoor", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Tonkuhle Alt Sührkow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Straßensee", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Düstersee (nördliche Fläche)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Alt Vorwerker Loch (Blanke / Düstere Moor Soll)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Sandsee (Großer Lunower See)", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Dorfteich Boddin", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Schwarzer See Teterow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Mieckower Torfloch", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Hopfensoll", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Krummer See Teschow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Haussee Schorssow", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Steinsoll", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Warbel", coordinate: CLLocationCoordinate2D(latitude: 53.7833, longitude: 12.5667)),
        Gewaesser(name: "Großer Varchentiner See", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.8500)),
        Gewaesser(name: "Großer Stadtsee Penzlin", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Malliner See", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Kleiner Varchentiner See", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.8500)),
        Gewaesser(name: "Sumpfsee Lärz", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 12.7500)),
        Gewaesser(name: "Ulrichshuser See", coordinate: CLLocationCoordinate2D(latitude: 53.5333, longitude: 13.2000)),
        Gewaesser(name: "Tangahnsee", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.8500)),
        Gewaesser(name: "Hinbergsee", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Kleiner Kressiner See", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.8500)),
        Gewaesser(name: "Klein Plastener See", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Kleiner Stadtsee Penzlin", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Hofsee Zahren", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Klein Lukower See", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Gliensee", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.6000)),
        Gewaesser(name: "Mönchsee", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Großer Düb", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.8500)),
        Gewaesser(name: "Wolfskuhlsee", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 12.6833)),
        Gewaesser(name: "Hofsee Deven", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Hofsee Rockow", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Rethwiese", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Rohrteich", coordinate: CLLocationCoordinate2D(latitude: 53.3833, longitude: 12.6000)),
        Gewaesser(name: "Holzhauersee", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Krummer See Kargow", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Hofsee Kargow", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Hofsee Federow", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Großes Barsch-Soll", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Bocksee", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Waupacksee", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Wokuhlsee", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Frauentrog (Frauentogsee)", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Neue Torfkuhle (Mevenort)", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Alte Torfkuhle (Mevenort)", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Beutinbach (Wurzenbach)", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Mühlengraben", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.0833)),
        Gewaesser(name: "Elde", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 12.8500)),
        Gewaesser(name: "Kalkloch", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Zierker See", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Käbelicksee", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 12.9333)),
        Gewaesser(name: "Großer Fürstenseer See", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Großer Brückentinsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Dabelower See", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Granziner See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 12.9333)),
        Gewaesser(name: "Lutowsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Pagelsee", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 12.9333)),
        Gewaesser(name: "Godendorfer See", coordinate: CLLocationCoordinate2D(latitude: 53.2667, longitude: 13.1500)),
        Gewaesser(name: "Krummer Woklowsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Plasterinsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Mürtzsee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Domjüchsee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Rothsee Neustrelitz", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Trünnensee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Großer Lanz", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Großer Prälanksee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Großer Gadowsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Röthsee", coordinate: CLLocationCoordinate2D(latitude: 53.2667, longitude: 13.1500)),
        Gewaesser(name: "Pfarrsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Kleiner Drewensee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Krummer See Godendorf", coordinate: CLLocationCoordinate2D(latitude: 53.2667, longitude: 13.1500)),
        Gewaesser(name: "Großer Bürgersee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Kleiner Bürgersee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Schleienpohl", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Pöhle", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Kleiner Lanz", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Großer Grünplansee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Stribbowsee", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 13.1000)),
        Gewaesser(name: "Kleiner Grünplansee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Wittpol", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Kalksee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Rohrsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Schmückersee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Kleiner Schwaberowsee", coordinate: CLLocationCoordinate2D(latitude: 53.2667, longitude: 13.1500)),
        Gewaesser(name: "Streiflingsee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Jägerpohl", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
    
        Gewaesser(name: "Glambecker See", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Großer Stiegsee", coordinate: CLLocationCoordinate2D(latitude: 53.2667, longitude: 13.1500)),
        Gewaesser(name: "Paterfitzsee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Krummer See Klein Trebbow", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Mittelsee", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Langer See Weisdin", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Krebssee Blumenholz", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.2667)),
        Gewaesser(name: "Rohrpöhle", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 13.1500)),
        Gewaesser(name: "Kammerkanal", coordinate: CLLocationCoordinate2D(latitude: 53.3667, longitude: 13.0667)),
        Gewaesser(name: "Schwanenteich Demmin", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Badekanal Demmin", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Schwarzer See (Ganschendorfer See)", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Torfstich an der Trebel", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Torfstich an der Peene", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Augraben", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Darguner Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Peene (Kummerower See bis Gützkower Fähre)", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.8500)),
        Gewaesser(name: "Peene (Neukalener Peene bis Aalwehr Teterow)", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.8500)),
        Gewaesser(name: "Peenekanal und Westpeene", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.8500)),
        Gewaesser(name: "Schwinge", coordinate: CLLocationCoordinate2D(latitude: 53.9000, longitude: 13.0333)),
        Gewaesser(name: "Tollense", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Trebel und Trebelkanal", coordinate: CLLocationCoordinate2D(latitude: 54.0167, longitude: 12.7667)),
        Gewaesser(name: "Tüzer See", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Großer See Siedenbollentin", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Hofsee Kaluberhof", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Krummer See Letzin", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Torfkuhle Altentreptow", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Dorfteich Tützpatz", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Mühlenteich Klein Teetzleben", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Kleiner See Siedenbollentin", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Schloßteich Gültz", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Röthsoll", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Weltziner See", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Großer Dorfteich Bartow", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Dorfteich Grischow", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Schönsee (Kalübber See)", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Torfkuhle an der Tollense", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Maschinengraben", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
    Gewaesser(name: "Kummerower See", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: 12.8500)),
        Gewaesser(name: "Malchiner See", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Rützenfelder See", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Großer See Basepohl", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Dorfteich Zettemin", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Kleiner See Basepohl", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Dröbel", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Dorfteich Demzin", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Mühlenteich Basedow", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Altes Torfmoor (Ziegeleigraben)", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Dorfteich Gessin", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Landratsgraben", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Streckersgraben", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Schlachtergraben", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Faule Kuhle", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Nickersee", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Dorfteich Liepen", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Bendunscher Graben", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "See am Seeberg", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Schwarzer See Jürgenstorf", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Entengraben", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Tonkuhle/Torfstich Stavenhagen", coordinate: CLLocationCoordinate2D(latitude: 53.7000, longitude: 13.0667)),
        Gewaesser(name: "Rehmelgraben", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Torfstich Schlafmann", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Dahmer Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Brudersdorfer Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
        Gewaesser(name: "Ostpeene", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 12.7667)),
    Gewaesser(name: "Tollensesee", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Reitbahnsee", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Torfstich Woggersin", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Wrechensee", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Hellsoll", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Mühlenteich (Hinterste Mühle)", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Nettelkuhl", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Neuer Karpfenteich", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Dorfteich Weitin", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Fünfeichener Teiche", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Gelbes Loch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Inselloch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Großes Konsumloch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Kleines Kosumloch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Grevesches Loch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Ihlenpool", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Torfloch Neubrandenburg", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Großes Klärbecken", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Blaues Loch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Hornsches Loch", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Ölmühlenbach", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Gätenbach", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
        Gewaesser(name: "Tollense", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Camminer See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Teschendorfer See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Stadtsee Woldegk", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Gramelower See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Plather See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Rehberger See (Balliner See)", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Mühlenteich Friedland", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Chemnitzer See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Unterer Dorfteich Neu Räse", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Kavelpaß I", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Kavelpaß II", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Neuendorfer Teich", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Langer See Rossow", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Stausee Friedland", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Kleiner See (Blankenhofer See)", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Neuer Bagger Woldegk", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Badebagger Woldegk", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Schwarzbagger Woldegk", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Hechtbagger Woldegk", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Dornbagger Woldegk", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Großer und Kleiner Fauler See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Haussee Pragsdorf", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Genzkower See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Schulzensee (Großer See)", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 13.5833)),
        Gewaesser(name: "Hinterer See", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Hertasee", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Torfstich Neverin", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 13.2333)),
    
        Gewaesser(name: "Schleiloch (Modderkuhle)", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 13.3000)),
        Gewaesser(name: "Sannbruch", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.3000)),
        Gewaesser(name: "Linde / Lindebach", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 13.3000)),
    Gewaesser(name: "Oberuckersee", coordinate: CLLocationCoordinate2D(latitude: 53.2333, longitude: 13.8833)),
        Gewaesser(name: "Datze", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Tollense und Oberbach", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Randkanal", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 13.2500)),
        Gewaesser(name: "Eixener See", coordinate: CLLocationCoordinate2D(latitude: 54.1667, longitude: 12.7167)),
        Gewaesser(name: "Dorfsee Kavelsdorf", coordinate: CLLocationCoordinate2D(latitude: 54.1667, longitude: 12.7167)),
        Gewaesser(name: "Krebssee Kavelsdorf", coordinate: CLLocationCoordinate2D(latitude: 54.1667, longitude: 12.7167)),
        Gewaesser(name: "Saaler Tongruben", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 12.5000)),
        Gewaesser(name: "Torfstich Plummendorf", coordinate: CLLocationCoordinate2D(latitude: 54.1667, longitude: 12.7167)),
        Gewaesser(name: "Torfkuhlen Bad Sülze", coordinate: CLLocationCoordinate2D(latitude: 54.1333, longitude: 12.6667)),
        Gewaesser(name: "Köpsches Moor", coordinate: CLLocationCoordinate2D(latitude: 54.1333, longitude: 12.6667)),
        Gewaesser(name: "Torfstiche Barth", coordinate: CLLocationCoordinate2D(latitude: 54.3667, longitude: 12.7167)),
        Gewaesser(name: "Großer Teich Marlow", coordinate: CLLocationCoordinate2D(latitude: 54.1500, longitude: 12.5667)),
        Gewaesser(name: "Barthe", coordinate: CLLocationCoordinate2D(latitude: 54.3667, longitude: 12.7167)),
    Gewaesser(name: "Recknitz", coordinate: CLLocationCoordinate2D(latitude: 54.0500, longitude: 12.5500)),
        Gewaesser(name: "Saaler Bach", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 12.5000)),
        Gewaesser(name: "Badeanstalt Grimmen", coordinate: CLLocationCoordinate2D(latitude: 54.1167, longitude: 13.0500)),
        Gewaesser(name: "Hechtteich Mannhagen", coordinate: CLLocationCoordinate2D(latitude: 54.2000, longitude: 13.1833)),
        Gewaesser(name: "Torfstiche Tribsees", coordinate: CLLocationCoordinate2D(latitude: 54.1000, longitude: 12.7667)),
        Gewaesser(name: "Jeeser See", coordinate: CLLocationCoordinate2D(latitude: 54.2000, longitude: 13.1833)),
        Gewaesser(name: "Koppelteich Reinkenhagen", coordinate: CLLocationCoordinate2D(latitude: 54.2000, longitude: 13.1833)),
        Gewaesser(name: "Schloßteich Griebenow", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 13.0500)),
        Gewaesser(name: "Baggersee Langsdorf", coordinate: CLLocationCoordinate2D(latitude: 54.1000, longitude: 12.7667)),
        Gewaesser(name: "Trebel", coordinate: CLLocationCoordinate2D(latitude: 54.1000, longitude: 12.7667)),
        Gewaesser(name: "Kronhorster Trebel", coordinate: CLLocationCoordinate2D(latitude: 54.1167, longitude: 13.0500)),
        Gewaesser(name: "Moorteich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Knieperteich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Großer Frankenteich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Bauernteich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Kleiner Frankenteich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Andershofer Teich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Voigdehäger Teich Stralsund", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.0833)),
        Gewaesser(name: "Zipker Bach", coordinate: CLLocationCoordinate2D(latitude: 54.3667, longitude: 12.7167)),
        Gewaesser(name: "Uhlenbäk", coordinate: CLLocationCoordinate2D(latitude: 54.3667, longitude: 12.7167)),
        Gewaesser(name: "Torfstich Alt Pastitz", coordinate: CLLocationCoordinate2D(latitude: 54.3833, longitude: 13.4000)),
        Gewaesser(name: "Kniepower See", coordinate: CLLocationCoordinate2D(latitude: 54.3833, longitude: 13.4000)),
        Gewaesser(name: "Garzer See", coordinate: CLLocationCoordinate2D(latitude: 54.3167, longitude: 13.3500)),
        Gewaesser(name: "Rosengartener Beek", coordinate: CLLocationCoordinate2D(latitude: 54.3833, longitude: 13.4000)),
        Gewaesser(name: "Sehrower Bach", coordinate: CLLocationCoordinate2D(latitude: 54.3500, longitude: 13.2833)),
        Gewaesser(name: "Dorfteich Treuen", coordinate: CLLocationCoordinate2D(latitude: 53.9500, longitude: 13.1167)),
        Gewaesser(name: "Zuckerkanal", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.3500)),
        Gewaesser(name: "Torfstiche Trantow", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 13.2000)),
        Gewaesser(name: "Stadtkuhle Jarmen", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.3500)),
        Gewaesser(name: "Torfkuhlen Jarmen-Tutow", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.3500)),
        Gewaesser(name: "Stadtkanal Jarmen", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.3500)),
        Gewaesser(name: "Kiessee Zarrenthin", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.3500)),
        Gewaesser(name: "Kanal Trantow", coordinate: CLLocationCoordinate2D(latitude: 53.9833, longitude: 13.2000)),
        Gewaesser(name: "Torfstiche Loitz", coordinate: CLLocationCoordinate2D(latitude: 53.9667, longitude: 13.1500)),
        Gewaesser(name: "Pinnower See (Westteil)", coordinate: CLLocationCoordinate2D(latitude: 53.6167, longitude: 13.0833)),
        Gewaesser(name: "Pinnower See (Ostteil)", coordinate: CLLocationCoordinate2D(latitude: 53.6167, longitude: 13.0833)),
        Gewaesser(name: "Straßensee Wangelkow", coordinate: CLLocationCoordinate2D(latitude: 53.6167, longitude: 13.0833)),
        Gewaesser(name: "Schloßsee Wrangelsburg", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Torfgewässer Lüssow", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.3500)),
        Gewaesser(name: "Hoher See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Pulower See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Küchensee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Schloßsee Jamitzow", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Schwarzer See Wrangelsburg", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Papendorfer See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Tongrube Rosenhagen", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Berliner See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Buggower See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Stresower See", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Scholwersee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Piese", coordinate: CLLocationCoordinate2D(latitude: 54.1667, longitude: 13.7667)),
        Gewaesser(name: "Birkenmoor", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Trünnelsee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Triensee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Beeksee", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Helmshäger Soll", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 13.4333)),
        Gewaesser(name: "Kleiner See Papendorf", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
    Gewaesser(name: "Kölpinsee", coordinate: CLLocationCoordinate2D(latitude: 53.4167, longitude: 12.9333)),
        Gewaesser(name: "Priesterwasser", coordinate: CLLocationCoordinate2D(latitude: 53.8667, longitude: 14.0833)),
        Gewaesser(name: "Mittelbek", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Ziese", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Peene-Süd-Kanal", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
        Gewaesser(name: "Mühlgraben", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Rosenhäger Beck", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Flottbeck", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Pötterbeck", coordinate: CLLocationCoordinate2D(latitude: 53.9333, longitude: 13.6167)),
        Gewaesser(name: "Ryckgraben / Ryck", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 13.4333)),
        Gewaesser(name: "Rienegraben", coordinate: CLLocationCoordinate2D(latitude: 54.0833, longitude: 13.4333)),
        Gewaesser(name: "Landgraben", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 13.5500)),
    Gewaesser(name: "Peene", coordinate: CLLocationCoordinate2D(latitude: 53.8500, longitude: 13.7000)),
        Gewaesser(name: "Kanal zur Uecker", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 14.0167)),
    Gewaesser(name: "Ueckermünder Heide", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 14.0667)),
        Gewaesser(name: "Tongrube Bärenkamp", coordinate: CLLocationCoordinate2D(latitude: 53.6833, longitude: 14.0833)),
        Gewaesser(name: "Altwigshagener See", coordinate: CLLocationCoordinate2D(latitude: 53.7000, longitude: 13.8333)),
        Gewaesser(name: "Rochower See", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 14.0167)),
        Gewaesser(name: "Grambiner Torfstiche", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 14.0167)),
        Gewaesser(name: "Tongruben Luckow", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 14.0167)),
        Gewaesser(name: "Dorfteich Vogelsang", coordinate: CLLocationCoordinate2D(latitude: 53.7333, longitude: 14.0167)),
    
        Gewaesser(name: "Weißer Graben", coordinate: CLLocationCoordinate2D(latitude: 53.4833, longitude: 14.1667)),
        Gewaesser(name: "Schloßsee Penkun", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 14.2500)),
        Gewaesser(name: "Lebehnscher See", coordinate: CLLocationCoordinate2D(latitude: 53.5333, longitude: 14.0833)),
    Gewaesser(name: "Löcknitzer See", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.2167)),
        Gewaesser(name: "Latzigsee", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 14.2000)),
        Gewaesser(name: "Haussee Rothenklempenow", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 14.2000)),
        Gewaesser(name: "Mittlerer Bürgersee (Schützenhaussee)", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 14.2500)),
        Gewaesser(name: "Schönhauser See", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 14.2333)),
        Gewaesser(name: "Kleiner See Koblentz", coordinate: CLLocationCoordinate2D(latitude: 53.5333, longitude: 14.1333)),
        Gewaesser(name: "Bürgersee (Bleiche)", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 14.2500)),
        Gewaesser(name: "Stadtsee Strasburg", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 13.7500)),
        Gewaesser(name: "Großer Kutzowsee", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 14.2833)),
        Gewaesser(name: "Bürgersee (Obersee)", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 14.2500)),
        Gewaesser(name: "Dorfsee (Wolliner See)", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 14.2500)),
        Gewaesser(name: "Schwennenzer See", coordinate: CLLocationCoordinate2D(latitude: 53.4167, longitude: 14.3333)),
        Gewaesser(name: "Gellinsee", coordinate: CLLocationCoordinate2D(latitude: 53.3500, longitude: 14.2667)),
        Gewaesser(name: "Dammsee", coordinate: CLLocationCoordinate2D(latitude: 53.3333, longitude: 14.3500)),
        Gewaesser(name: "Glambecksee", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 14.2833)),
        Gewaesser(name: "Darschkower See", coordinate: CLLocationCoordinate2D(latitude: 53.5333, longitude: 13.8833)),
        Gewaesser(name: "Flachsee", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 14.2833)),
        Gewaesser(name: "Lankesee", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 14.2500)),
        Gewaesser(name: "Priestersee", coordinate: CLLocationCoordinate2D(latitude: 53.3333, longitude: 14.3500)),
        Gewaesser(name: "Erdkuhle", coordinate: CLLocationCoordinate2D(latitude: 53.5833, longitude: 13.9333)),
        Gewaesser(name: "Kleiner See Pasenow", coordinate: CLLocationCoordinate2D(latitude: 53.5000, longitude: 14.1167)),
        Gewaesser(name: "Schmiedesee", coordinate: CLLocationCoordinate2D(latitude: 53.3333, longitude: 14.3500)),
        Gewaesser(name: "Schwarzer See", coordinate: CLLocationCoordinate2D(latitude: 53.5500, longitude: 14.1833)),
        Gewaesser(name: "Hoffsee", coordinate: CLLocationCoordinate2D(latitude: 53.4167, longitude: 14.3333)),
        Gewaesser(name: "Sonnenberger See", coordinate: CLLocationCoordinate2D(latitude: 53.4167, longitude: 14.3333)),
        Gewaesser(name: "Teich Rosenthal", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 13.7500)),
        Gewaesser(name: "Mühlensee", coordinate: CLLocationCoordinate2D(latitude: 53.4167, longitude: 14.3333)),
        Gewaesser(name: "Leichensee", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.2167)),
        Gewaesser(name: "Seggepuhl", coordinate: CLLocationCoordinate2D(latitude: 53.4333, longitude: 14.0667)),
        Gewaesser(name: "Klarer See", coordinate: CLLocationCoordinate2D(latitude: 53.3500, longitude: 14.2667)),
        Gewaesser(name: "Fauler See", coordinate: CLLocationCoordinate2D(latitude: 53.3500, longitude: 14.2667)),
        Gewaesser(name: "Großer Diebelpohl", coordinate: CLLocationCoordinate2D(latitude: 53.3500, longitude: 14.2667)),
        Gewaesser(name: "Kleiner Diebelpohl", coordinate: CLLocationCoordinate2D(latitude: 53.3500, longitude: 14.2667)),
        Gewaesser(name: "Haussee / Röthsee", coordinate: CLLocationCoordinate2D(latitude: 53.5333, longitude: 13.9167)),
        Gewaesser(name: "Kleiner Löcknitzer See", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.2167)),
        Gewaesser(name: "Demenzsee", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 13.7500)),
        Gewaesser(name: "Kossätensee", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 14.2000)),
        Gewaesser(name: "Storkower See", coordinate: CLLocationCoordinate2D(latitude: 53.3167, longitude: 14.2000)),
        Gewaesser(name: "Kiessee", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 14.0833)),
        Gewaesser(name: "Karutzenbruch", coordinate: CLLocationCoordinate2D(latitude: 53.3333, longitude: 14.3500)),
        Gewaesser(name: "Großer See Rossow", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 14.1167)),
        Gewaesser(name: "Kleiner See Rossow", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 14.1167)),
        Gewaesser(name: "Dorfteich Damerow", coordinate: CLLocationCoordinate2D(latitude: 53.4667, longitude: 14.0000)),
        Gewaesser(name: "Krummer See", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.0000)),
        Gewaesser(name: "Düster See", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.0000)),
        Gewaesser(name: "Bibelpfuhl", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.0000)),
        Gewaesser(name: "Barspfuhl", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.0000)),
        Gewaesser(name: "Auslathsee", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.0000)),
        Gewaesser(name: "Düstersee", coordinate: CLLocationCoordinate2D(latitude: 53.3500, longitude: 14.2667)),
        Gewaesser(name: "Hellteich", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 13.7500)),
        Gewaesser(name: "Schmiedegrundsee", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 13.7500)),
        Gewaesser(name: "Schmiedepfuhl", coordinate: CLLocationCoordinate2D(latitude: 53.4500, longitude: 14.0000)),
        Gewaesser(name: "Panzerkuhle", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 14.0833)),
        Gewaesser(name: "Schweinekuhle", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 14.0833)),
        Gewaesser(name: "Schleienloch", coordinate: CLLocationCoordinate2D(latitude: 53.5167, longitude: 14.0833)),
        Gewaesser(name: "Ludwigshofer See", coordinate: CLLocationCoordinate2D(latitude: 53.6667, longitude: 14.1333)),
        Gewaesser(name: "Haussee Wolfshagen", coordinate: CLLocationCoordinate2D(latitude: 53.1833, longitude: 13.9333)),
        Gewaesser(name: "Menkiner See", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8833)),
        Gewaesser(name: "Kleiner Wüstenteich", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8333)),
        Gewaesser(name: "Grünberger See", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8333)),
        Gewaesser(name: "Dunkersee", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8333)),
        Gewaesser(name: "Großer Wüstenteich", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8333)),
        Gewaesser(name: "Zollochsee", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8333)),
        Gewaesser(name: "Gretenbruch", coordinate: CLLocationCoordinate2D(latitude: 53.3000, longitude: 13.8333))
    
    
    

    ]

/*
#Preview {
    ContentView()
}
*/
