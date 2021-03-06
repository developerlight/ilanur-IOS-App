//
//  AdhanView.swift
//  ilanur
//
//  by Developer Light on 1.07.2022.
//

import SwiftUI
import MapKit
import Contacts
import Adhan

struct AdhanView: View {
    
    @State var cityName = "--"

    @ObservedObject var locationManager = LocationManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    let radius = 12
//  Hafta günlerini türkçeye çevirme
    var today: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        //or formatter.locale = .autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: date)
    }
    
//  Tarih ay türkçe ye çevirme
    var month: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        //or formatter.locale = .autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter.string(from: date)
    }
    
    let prayers: [Prayer] = [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
    
    var body: some View {
        if locationManager.userLocation == nil {
            RequestLocationView()
        } else if (locationManager.userLocation != nil)  {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(cityName)
                        .bold().font(.title)
                    Text("Bugün, \(Date.now.formatted(.dateTime.year())) \(month) \(today)")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                VStack {
                    Text(LocationManager().nextPrayer()!,style: .timer)
                        .font(.system(size: 50))
                    nextPrayer()
                        .font(.body)
                }
                Spacer()
                Divider()
                VStack {
                    HStack {
                        SheetView(name: formattedPrayer(prayer:prayers[0], times: LocationManager().prayerTimes()), value: formattedPrayerTimes(prayer: prayers[0], times: LocationManager().prayerTimes()))
                            .frame(maxWidth:.infinity, alignment: .center)
                        Divider()
                            .padding(.top)
                        SheetView(name: formattedPrayer(prayer:prayers[1], times: LocationManager().prayerTimes()), value: formattedPrayerTimes(prayer: prayers[1], times: LocationManager().prayerTimes()))
                            .frame(maxWidth:.infinity, alignment: .center)
                    }
                    Divider()
                    HStack {
                        SheetView(name: formattedPrayer(prayer:prayers[2], times: LocationManager().prayerTimes()), value: formattedPrayerTimes(prayer: prayers[2], times: LocationManager().prayerTimes()))
                            .frame(maxWidth:.infinity, alignment: .center)

                        Divider()
                            .padding(.top)
                        SheetView(name: formattedPrayer(prayer:prayers[3], times: LocationManager().prayerTimes()), value: formattedPrayerTimes(prayer: prayers[3], times: LocationManager().prayerTimes()))
                            .frame(maxWidth:.infinity, alignment: .center)

                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                getCity()
            }
        }
    }
//    şehir adı
    func getCity() {
        let location = CLLocation(latitude: locationManager.manager.location?.coordinate.latitude ?? 0, longitude: locationManager.manager.location?.coordinate.longitude ?? 0)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, error == nil else { return }
            cityName = city
        }
    }
    
//    Bir sonraki ezanin adı
    func nextPrayer(at time: Date = Date()) -> some View {
        if LocationManager().prayerTimes()?.isha.timeIntervalSince(time) ?? 0 <= 0 {
            return Text("Gece Yarısı")
        } else if LocationManager().prayerTimes()?.maghrib.timeIntervalSince(time) ?? 0 <= 0 {
           return Text("Yatsı")
        } else if LocationManager().prayerTimes()?.asr.timeIntervalSince(time) ?? 0 <= 0 {
           return Text("Akşam")
        } else if LocationManager().prayerTimes()?.dhuhr.timeIntervalSince(time) ?? 0 <= 0 {
           return Text("İkindi")
        } else if LocationManager().prayerTimes()?.sunrise.timeIntervalSince(time) ?? 0 <= 0 {
           return Text("Öğle")
        } else if LocationManager().prayerTimes()?.fajr.timeIntervalSince(time) ?? 0 <= 0 {
           return Text("Güneş")
        }
        return Text("İmsak")
   }
//    Ezan vakitlerin saatini belirleme
    func formattedPrayerTimes(prayer: Prayer,times: PrayerTimes?) -> Date {
        switch prayer {
        case .fajr:
            return times!.fajr
        case .sunrise:
            return times!.sunrise
        case .dhuhr:
            return times!.dhuhr
        case .asr:
            return times!.asr
        case .maghrib:
            return times!.maghrib
        case .isha:
            return times!.isha
        }
    }
    
//    Ezan vakitlerin isimleri belirleme
    func formattedPrayer(prayer: Prayer, times: PrayerTimes?) -> String {
        switch prayer {
        case .fajr:
            return "İmsak"
        case .sunrise:
            return "Güneş"
        case .dhuhr:
            return "Öğle"
        case .asr:
            return "İkindi"
        case .maghrib:
            return "Akşam"
        case .isha:
            return "Yatsı"
        }
    }
}

struct AdhanView_Previews: PreviewProvider {
    static var previews: some View {
        AdhanView()
    }
}
