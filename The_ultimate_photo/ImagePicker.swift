//
//  ImagePicker.swift
//  The_ultimate_photo
//
//  Created by Sai Charan  on 1/5/24.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        // Giving the photolibrary access to app using UIImagepickerController
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator //Used to detect which particular picture is selected-Event handling
        
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker){
        self.parent = picker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // When selected image
        print("Image Selected")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //We get the image that is selected
            DispatchQueue.main.async{
                self.parent.selectedImage = image
            }
        }
        //Go back to the home screen
        parent.isPickerShowing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // When cancelled the event
        print("Cancelled")
        //Go back to the home screen
        parent.isPickerShowing = false
    }
}
