import Foundation
import SwiftUI


//v0.2.7
public func systemUptimeInSeconds() -> TimeInterval {
    let uptime = ProcessInfo.processInfo.systemUptime
    return uptime
}

public func getDeviceIdentifier() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)

    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let machineIdentifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }

    return machineIdentifier
}
public func getArch() -> String? {
    var size: size_t = MemoryLayout<cpu_type_t>.size
    var cpuType: cpu_type_t = 0

    if sysctlbyname("hw.cputype", &cpuType, &size, nil, 0) != 0 {
        return nil
    }

    var subType: cpu_subtype_t = 0
    size = MemoryLayout<cpu_subtype_t>.size

    if sysctlbyname("hw.cpusubtype", &subType, &size, nil, 0) != 0 {
        return nil
    }

    let cpuArch: String

    switch Int32(cpuType) {
    case CPU_TYPE_ARM:
        switch subType {
        case CPU_SUBTYPE_ARM_V6:
            cpuArch = "armv6"
        case CPU_SUBTYPE_ARM_V7:
            cpuArch = "armv7"
        case CPU_SUBTYPE_ARM_V7S:
            cpuArch = "armv7s"
        default:
            cpuArch = "arm"
        }
    case CPU_TYPE_ARM64:
        switch subType {
        case CPU_SUBTYPE_ARM64_ALL:
            cpuArch = "arm64"
        default:
            cpuArch = "arm64"
        }
    default:
        cpuArch = "Unknown"
    }

    return cpuArch
}
func getDarwinVersion() -> String? {
    var sysinfo = utsname()
    uname(&sysinfo)

    let releaseData = Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN))

    let version = releaseData.withUnsafeBytes {
        String(cString: $0.baseAddress!.assumingMemoryBound(to: CChar.self))
    }

    return version
}
public func getiOSVersion() -> String {
    return UIDevice.current.systemVersion
}
func folderExists(atPath path: String) -> Bool {
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false
    
    // Check if the item at the specified path exists and is a directory
    return fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
}
func createFolder(atPath path: String) -> Bool {
    let fileManager = FileManager.default
    try? fileManager.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true)
    if folderExists(atPath: path) {
        return true
    }
    return false
}

//v0.3.1
public func deleteFileInDocumentsDirectory(fileName: String) {
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
public func deleteAllFilesInDocumentsDirectory() {
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
public func checkIfFileExists(fileName: String) -> Bool {
    let filePath = documentDirectoryURL().appendingPathComponent(fileName)
    return FileManager.default.fileExists(atPath: filePath.path)
}
public func documentDirectoryURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
