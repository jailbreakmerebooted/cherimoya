import Foundation

func fileExists() -> Bool {
    // Get the Documents directory
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        // Append the file name to the Documents directory
        let fileURL = documentsDirectory.appendingPathComponent(".jbip")
        
        // Check if the file exists
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    // Return false if unable to get the Documents directory
    return false
}
// Function to create the file
func createFile() {
    // Get the Documents directory
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        // Append the file name to the Documents directory
        let fileURL = documentsDirectory.appendingPathComponent(".jbip")
        
        // Check if the file already exists
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // Create an empty file at the specified URL
                try "".write(to: fileURL, atomically: true, encoding: .utf8)
                print("File created successfully at \(fileURL.path)")
            } catch {
                print("Error creating file: \(error.localizedDescription)")
            }
        } else {
            print("File already exists at \(fileURL.path)")
        }
    }
}

// Function to delete the file
func deleteFile() {
    // Get the Documents directory
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        // Append the file name to the Documents directory
        let fileURL = documentsDirectory.appendingPathComponent(".jbip")
        
        // Check if the file exists before attempting to delete it
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // Delete the file at the specified URL
                try FileManager.default.removeItem(at: fileURL)
                print("File deleted successfully at \(fileURL.path)")
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist at \(fileURL.path)")
        }
    }
}
