import SwiftUI
import Foundation
import libzstd

struct haxx: View {
    init() {
            iOS = Float(getiOSVersion()) ?? 0.0
            restorerfs = false
    }
    @ViewBuilder func Line2(_ str: String) -> some View {
        HStack {
            Text(str)
                .font(.system(size: 7, weight: .semibold))
            Spacer()
        }
    }
    private let segments = [ "Rootless", "Roothide"]
    static let cheri = Cherimoya()
    let backgroundQueue = DispatchQueue(label: "com.example.backgroundQueue", qos: .background)
    let consoleInstance = Console2()
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @State var uptime: Int = 0
    @State var iOS: Float = 0.0
    @State var respi: Bool = false
    @State var cooldown: String = ""
    @State var settings: Bool = false
    @State var play: Bool = false
    @State var rdbs: Bool = false
    @State var isJailbreaking: Bool = false
    @State var paniced: Bool = false
    @State var bootstrap: Int = 1
    @AppStorage("themed") var themed: Bool = false
    @AppStorage("bstrp") var selectedSegment = 0
    @AppStorage("uptimecalc") var uptimecalc: Double = 0.0
    @AppStorage("altsu") var alstup: Bool = false
    @AppStorage("c_enabled") var cooldown_enabled: Bool = false
    @AppStorage("jbrooott") var jbroot: String = ""
    @AppStorage("rfs") var restorerfs: Bool = false
    @AppStorage("rie") var respring_in_end: Bool = true
    @ObservedObject var c = Console2.shared
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: deviceWidth - 125)
                    .onAppear {
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let documents = documentsURL.path
                        if !folderExists(atPath: documents + "/cherimoya") {
                            if createFolder(atPath: documents + "/cherimoya") {
                                Console2.shared.log("[+] created dependend folder")
                            }
                        }
                        selectedSegment = 0
                        
                        if fileExists() {
                            paniced = true
                            settings = true
                            Console2.shared.log(String(paniced ? "[*] paniced: true" : "[*] paniced: false"))
                            deleteFile()
                        }
                    }
                Spacer().frame(height: 20)
                ZStack {
                    Rectangle()
                        .frame(width: deviceWidth - 75 ,height: deviceHeight / 3)
                        .cornerRadius(15)
                        .foregroundColor(.black)
                        .opacity(0.9)
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(0..<c.lines.count, id: \.self) { i in
                                    let item = c.lines[i]
                                    
                                    Line2(item)
                                        .foregroundColor(.green)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(4)
                            .flipped()
                        }
                        .frame(width: deviceWidth - 90 ,height: deviceHeight / 3)
                        .padding(.horizontal)
                        .flipped()
                    }
                    .padding()
                }
                Spacer().frame(height: 10)
                HStack {
                    Button(action: {
                        settings = true
                    }) {
                        Rectangle()
                            .frame(width: 50, height: 50)
                            .cornerRadius(2)
                            .foregroundColor(.black)
                            .overlay {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.green)
                                    .scaledToFill()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.green, lineWidth: 2) // Adjust the width of the green border as needed
                            )
                    }
                    .sheet(isPresented: $settings) {
                        if !paniced {
                            NavigationView {
                                List {
                                    Section(header: Text("Bootstrap")) {
                                        Picker(selection: $selectedSegment, label: Text("")) {
                                            ForEach(0..<segments.count) { index in
                                                Text(self.segments[index])
                                                    .tag(index)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .padding()
                                        .disabled(true)
                                        Button(action: {
                                            if checkInternetConnection() {
                                                deleteDownloadedFile()
                                            } else {
                                                Console2.shared.log("[-] refused to delete the resources cache cause youre offline or our server is offline")
                                            }
                                        }) {
                                            Label {
                                                Text("Clear Resources Cache")
                                                    .foregroundColor(.primary)
                                            } icon: {
                                                Image(systemName: "xmark.bin")
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                    }
                                    Section(header: Text("Settings")) {
                                        Toggle(isOn: $respring_in_end) {
                                            Label {
                                                Text("Respring")
                                            } icon: {
                                                Image(systemName: "gobackward")
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        .tint(.orange)
                                        .disabled(isJailbroken())
                                        Toggle(isOn: $cooldown_enabled) {
                                            Label {
                                                Text("Cooldown")
                                            } icon: {
                                                Image(systemName: "stopwatch")
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        .tint(.orange)
                                        .disabled(isJailbroken())
                                    }
                                    Toggle(isOn: $restorerfs) {
                                        Label {
                                            Text("Remove Jailbreak")
                                        } icon: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .tint(.red)
                                    .disabled(isJailbroken())
                                    Section {
                                        NavigationLink(destination: AA()) {
                                            Label {
                                                Text("Alternative Icons")
                                            } icon: {
                                                Image(systemName: "app.badge")
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        Button("Themes") {
                                            themed = false
                                        }
                                    }
                                    .accentColor(.primary)
                                    NavigationLink(destination: CreditsView()) {
                                        Label {
                                            Text("Credits")
                                                .foregroundColor(.primary)
                                        } icon: {
                                            Image(systemName: "person.3")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                .navigationTitle("Settings")
                            }
                        } else {
                            ZStack {
                                VStack {
                                    Spacer()
                                    Spacer().frame(height: 20)
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(colorScheme == .dark ? .black : .white)
                                        .frame(width: deviceWidth - 240)
                                    Spacer().frame(height: 40)
                                    List {
                                        Section {
                                            Text("Opps Something went wrong")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.red)
                                        }
                                        Section(header: Text("Info")) {
                                            Text("""
Your Device seems to have paniced. Please contact SeanIsTethered on Twitter if these troubleshootings doesnt work.
""")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.orange)
                                        }
                                        Section(header: Text("Troubleshoot")) {
                                            Text("""
Here are some Troubleshooting ways :)

1. Reboot Device manually
2. Clear Resources Cache
3. Enable Cooldown
4. Contact me -> ceo@polcom.de
""")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.yellow)
                                        }
                                    }
                                    .frame(width: deviceWidth - 50, height: deviceHeight / 2)
                                    .cornerRadius(15)
                                    Spacer().frame(height: 20)
                                    Button(action: {
                                        paniced = false
                                        settings = false
                                        deleteFile()
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .frame(width: deviceWidth - 50, height: 50)
                                                .foregroundColor(.yellow)
                                                .cornerRadius(10)
                                                .overlay {
                                                    Text("Continue")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(.primary)
                                                }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        }
                    if !isJailbreaking {
                        Button(action: {
                            if #unavailable(iOS 15.2) {
                                if !isJailbreaking {
                                    withAnimation {
                                        isJailbreaking = true
                                    }
                                    if iOS < 15.2 {
                                        if checkIfFileExists(fileName: "bootstrap-iphoneos-arm64.tar") == false {
                                            Console2.shared.log("[-] Bootstrap missing")
                                            _offsets_init()
                                            deleteDownloadedFileJB()
                                        } else {
                                            DispatchQueue.global(qos: .background).async {
                                                createFile()
                                                _offsets_init()
                                                if cooldown_enabled == true {
                                                    uptime_cooldown()
                                                } else {
                                                    fakeprogress()
                                                }
                                            }
                                        }
                                    } else if iOS < 16.5 {
                                        Console2.shared.log("[-] sorry but your device is currently unsupported")
                                    } else {
                                        Console2.shared.log("[-] sorry your device is not in V3 range and will never be supported with current public hack abilities")
                                    }
                                }
                            }
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: deviceWidth - 190 ,height: 50)
                                    .foregroundColor(/*blcked ? .gray : isJailbroken() ? .red :*/ .black)
                                    .opacity(/*blcked ? 0.6 : */isJailbroken() ? 0.6 : 1.0)
                                    .overlay {
                                        /*if !blcked {*/
                                        if #unavailable(iOS 15.2) {
                                            Text(isJailbroken() ? "Jailbroken" : isJailbreaking ? "exploiting..." : "Jailbreak")
                                                .foregroundColor(.green)
                                        } else {
                                            Text("Unsupported")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color.green, lineWidth: 2) // Adjust the width of the green border as needed
                                    )
                            }
                        }
                        .disabled(isJailbreaking ? true : isJailbroken() ? true : false)
                    }
                    Button(action: {
                        backgroundQueue.async {
                            audioPlayerManager.togglePlay()
                        }
                    }) {
                        Rectangle()
                            .frame(width: 50 ,height: 50)
                            .foregroundColor(.black)
                            .overlay {
                                Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                                    .resizable()
                                    .frame(width: 20 ,height: 20)
                                    .foregroundColor(.green)
                                    .scaledToFill()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.green, lineWidth: 2) // Adjust the width of the green border as needed
                            )
                    }
                }
            }
            .frame(width: deviceWidth, height: deviceHeight)
    }
    func jailbreak_latecall() {
        jailbreak(respring_in_end, restorerfs, Int32(selectedSegment))
        Thread.sleep(forTimeInterval: 2.0)
    }
    func startDownload() {
        // Reset download progress and size
        Console2.shared.log("[*] downloading")
        let fileDownloader = FileDownloader()
        
        fileDownloader.downloadFile(from: "https://apt.procurs.us/bootstraps/1800/bootstrap-iphoneos-arm64.tar.zst") { (url, error) in
            if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
                Console2.shared.log("[-] failed downloading bootstrap")
            } else if let url = url {
                print("File downloaded successfully at \(url.absoluteString)")
                Console2.shared.log("[+] downloaded bootstrap successfully")
                preparebs()
            }
        }
        
        // Simulate download progress updates
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
        }
    }
    func deleteFileInDocumentsDirectory(fileName: String) {
        // Get the document directory URL
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // Create the file URL by appending the file name
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            do {
                // Check if the file exists before attempting to delete it
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    // Delete the file
                    try FileManager.default.removeItem(at: fileURL)
                    print("File deleted successfully.")
                } else {
                    print("File does not exist at path: \(fileURL.path)")
                }
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        } else {
            print("Could not access documents directory.")
        }
    }
    func renameFileInDocumentsDirectory(oldFileName: String, newFileName: String) {
        let fileManager = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let oldFileURL = documentsDirectory.appendingPathComponent(oldFileName)
        let newFileURL = documentsDirectory.appendingPathComponent(newFileName)
        
        do {
            try fileManager.moveItem(at: oldFileURL, to: newFileURL)
            print("File renamed successfully.")
        } catch {
            print("Error renaming file: \(error.localizedDescription)")
        }
    }
    func deleteDownloadedFile() {
        deleteAllFilesInDocumentsDirectory()
        
        // Reset download progress and size
    }
    func deleteDownloadedFileJB() {
        deleteAllFilesInDocumentsDirectory()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documents = documentsURL.path
        print(documents + "/cherimoya")
        if createFolder(atPath: documents + "/cherimoya") {
            if folderExists(atPath: documents + "/cherimoya") {
                startDownload()
            } else {
                Console2.shared.log("[-] dependend folder missing")
            }
        }
    }
    func deleteAllFilesInDocumentsDirectory() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])

            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
                print("Deleted file: \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error deleting files: \(error)")
        }
    }
    func decompressAndSaveZstdFile(inputFilePath: String) {
        // Create output file path for decompressed data
        let outputFileName = (inputFilePath as NSString).deletingPathExtension
        let outputFilePath = outputFileName + "_decompressed" + "." + (inputFilePath as NSString).pathExtension

        // Read compressed data from file
        guard let compressedData = FileManager.default.contents(atPath: inputFilePath) else {
            print("Failed to read compressed data from file")
            return
        }

        // Estimate the decompressed size
        var dstCapacity: UInt64 = 0
        compressedData.withUnsafeBytes { srcBuffer in
            dstCapacity = ZSTD_getDecompressedSize(srcBuffer.baseAddress, compressedData.count)
        }
        guard dstCapacity > 0 else {
            print("Invalid compressed data")
            return
        }

        // Allocate buffer for decompressed data
        var decompressedData = Data(count: Int(dstCapacity))

        // Decompress the data
        decompressedData.withUnsafeMutableBytes { dstBuffer in
            compressedData.withUnsafeBytes { srcBuffer in
                let decompressedSize = ZSTD_decompress(dstBuffer.baseAddress, Int(dstCapacity), srcBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self), compressedData.count)
                guard decompressedSize > 0 else {
                    print("Failed to decompress data")
                    return
                }
            }
        }

        // Save decompressed data to a new file in the same directory
        FileManager.default.createFile(atPath: outputFilePath, contents: decompressedData, attributes: nil)

        print("Decompression successful. Decompressed data saved to: \(outputFilePath)")
    }
    //Downloader
    class FileDownloader {
        var downloadProgress: Int = 0 {
            didSet {
                print("Download Progress: \(downloadProgress)%")
            }
        }

        func downloadFile(from urlString: String, completion: @escaping (URL?, Error?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }
            
            let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(nil, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                    return
                }
                
                guard let tempURL = tempURL else {
                    completion(nil, NSError(domain: "Invalid temporary URL", code: 0, userInfo: nil))
                    return
                }
                
                do {
                    let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
                    
                    try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                    
                    self.downloadProgress = 100 // Set progress to 100% upon completion
                    completion(destinationURL, nil)
                } catch {
                    completion(nil, error)
                }
            }
            
            task.resume()
        }
    }
    func preparebs() {
        let lol = "/bootstrap-iphoneos-arm64.tar.zst"
        let lol2 = "bootstrap-iphoneos-arm64.tar_decompressed.zst"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentsDirectory.appendingPathComponent(lol)
            let filePath2 = documentsDirectory.appendingPathComponent(lol2)
            Console2.shared.log("[*] decompress zstd")
            decompressAndSaveZstdFile(inputFilePath: filePath.path)
            Thread.sleep(forTimeInterval: 2.0)
            Console2.shared.log("[*] renaming decompressed zstd")
            renameFileInDocumentsDirectory(oldFileName: "bootstrap-iphoneos-arm64.tar_decompressed.zst", newFileName: "bootstrap-iphoneos-arm64.tar")
            Console2.shared.log("[*] deletiting source files")
            deleteFileInDocumentsDirectory(fileName: "bootstrap-iphoneos-arm64.tar_decompressed.zst")
            deleteFileInDocumentsDirectory(fileName: "bootstrap-iphoneos-arm64.tar.zst")
            Thread.sleep(forTimeInterval: 2.0)
            Console2.shared.log("[+] ready to jailbreak!")
            Thread.sleep(forTimeInterval: 3.0)
            jailbreak_latecall()
        }
    }

    func checkIfFileExists(fileName: String) -> Bool {
        let filePath = documentDirectoryURL().appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: filePath.path)
    }

    func documentDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func amiactive() -> Bool {
        return true
    }
    /*func countdown(startingFrom initialValue: Int) {
        var count = initialValue
        blcked = true
        while count >= 0 {
            print(count)
            count -= 1
            cooldown = String(count)
            sleep(1)
            // You can add a delay here if you want to slow down the countdown, for example:
            // Thread.sleep(forTimeInterval: 1.0) // 1 second delay
        }
        blcked = false
        print("Countdown complete!")
    }*/
    public func respi_set() {
        respi = true
    }
    public func uptime_cooldown() {
        var tim = 1.0
        var hello = 40
        Console2.shared.log("[*] cooldowning")
        Console2.shared.log("[")
        while hello != 0 {
            Console2.shared.appendCharacterToLatestLine(Character("="))
            Thread.sleep(forTimeInterval: tim)
            hello -= 1
            print(hello)
        }
        Console2.shared.appendCharacterToLatestLine(Character("]"))
        fakeprogress()
    }
    public func fakeprogress() {
        var hello = 40
        Console2.shared.log("[*] exploiting kernel")
        Console2.shared.log("[")
        while hello != 0 {
            Console2.shared.appendCharacterToLatestLine(Character("="))
            Thread.sleep(forTimeInterval: 0.05)
            hello -= 1
            print(hello)
        }
        Console2.shared.appendCharacterToLatestLine(Character("]"))
        jailbreak_latecall()
    }
    func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            let fileManager = FileManager.default
            
            // Check for common jailbreak files
            let jailbreakFilepaths = [
                "/var/jb/.installed_cherimoya",
            ]
            
            for path in jailbreakFilepaths {
                if fileManager.fileExists(atPath: path) {
                    return true
                }
            }
            
            // Check for symbolic links that are indicative of a jailbreak
            let symbolicLinks = ["/Applications", "/Library/Ringtones", "/Library/Wallpaper", "/usr/arm-apple-darwin9", "/var/tmp/cydia"]
            
            for path in symbolicLinks {
                if let attributes = try? fileManager.attributesOfItem(atPath: path), let type = attributes[.type] as? String, type == FileAttributeType.typeSymbolicLink.rawValue {
                    return true
                }
            }
            
            return false
        #endif
    }
}
