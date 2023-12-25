import SwiftUI

struct Credit: Identifiable {
    var id = UUID()
    var name: String
    var role: String
    var profileImage: String
    var description: String
}

struct CreditsView: View {
    let credits: [Credit] = [
        Credit(name: "SeanIsTethered", role: "Main Developer", profileImage: "seanistethered", description: "arm64 jb stuff"),
        Credit(name: "noah", role: "Main Developer", profileImage: "rebeldisc", description: "arm64e jb stuff"),
        Credit(name: "pwned4ever", role: "Important Developer", profileImage: "pwned4ever", description: "FREYA15 (1.0.5)"),
        Credit(name: "wh1te4ever", role: "Important Developer", profileImage: "h4e", description: "kfund"),
        Credit(name: "Évelyne", role: "Developer", profileImage: "eve", description: "ElleKIT (1.1)"),
        Credit(name: "Procursus", role: "Developer", profileImage: "pro", description: "Procursus Bootstrap and openssh"),
    ]
    let creditss: [Credit] = [
        Credit(name: "Opa334", role: "Exploit", profileImage: "opa334", description: "iOSurface krw method"),
        Credit(name: "felix-pb", role: "Exploit", profileImage: "felix", description: "KernelFileDescriptor Exploit"),
    ]
    var body: some View {
        List {
            Section {
                ForEach(credits) { credit in
                        CreditRowView(credit: credit)
                }
            }
            Section {
                ForEach(creditss) { credit in
                    CreditRowView(credit: credit)
                }
            }
        }
        .navigationTitle("Credits")
    }
}

struct CreditRowView: View {
    var credit: Credit

    var body: some View {
        HStack {
            Image(credit.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 0.5))

            VStack(alignment: .leading, spacing: 4) {
                Text(credit.name)
                    .font(.system(size: 11, weight: .bold))

                Text(credit.role)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.gray)

                Text(credit.description)
                    .font(.system(size: 8, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.leading, 8)
            .padding(.trailing, 16) // Adjust this value as needed
        }
        .padding(8)
    }
}
