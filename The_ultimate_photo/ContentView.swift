//
//  ContentView.swift
//  The_ultimate_photo
//
//  Created by Sai Charan  on 1/5/24.
//

import SwiftUI
import FirebaseStorage

struct ContentView: View {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var image: Image =
    Image(systemName: "")
    @State var showingAlert = false
    @State var isPickerShowing = false
    @State private var sourceType : UIImagePickerController.SourceType = .camera
    @State var selectedImage: UIImage?
    @State private var isShown: Bool = false
    
    var body: some View {
        
            VStack {
                Rectangle()
                    .fill(Gradient(colors: [.blue, .purple]))
                    .ignoresSafeArea()
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                Button {
                    //This shows the image picker
                    isPickerShowing = true
                }
            label: {
                Text("Select image from gallery").padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .font(.title)
            }
                
                Button {
                    //This shows the image picker
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.allowsEditing = true
                    
                    if let viewController = UIApplication.shared.windows.first?.rootViewController {
                            viewController.present(vc, animated: true)
                        }
                }
            label: {
                Text("Use Camera").padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .font(.title)
                
            }
                
                Rectangle()
                    .fill(Gradient(colors: [.indigo, .purple]))
                    .ignoresSafeArea()
                if selectedImage != nil {
                    Button{
                        // Upload the image
                        uploadImage()
                        showingAlert = true
                    }
                label: {
                    Text("Upload the image").padding()
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .font(.title)
                }
                }
            }
        
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                //This has to pick images using UIImagePickerController
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
            .alert("Succesfully uploaded to cloud", isPresented: $showingAlert) {
            
            }
        
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
    }
    
    
    /*func showCam(selSource: UIImagePickerController.SourceType)
    {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate
            imagePickerController.sourceType = selSource
            imagePickerController.allowsEditing = false
    }*/

        func uploadImage() {
            guard selectedImage != nil else {
                return
            }
            
            //creating the reference for storing images
            let strRef = Storage.storage().reference()
            
            //turning our images into data to store
            let imgdata = selectedImage!.jpegData(compressionQuality: 0.9)
            
            // chcecking whether the data converted or not
            guard imgdata != nil else {
                return
            }
            
            // creating reference to image in the image folder of firebase
            let fileRef = strRef.child("images/\(UUID().uuidString).jpeg")
            
            //uploading the data
            _ = fileRef.putData(imgdata! , metadata: nil) {
                metadata, error in
                
                if error == nil && metadata != nil {
                    
                }
            }
        }
    
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct A: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var myimage: Image
    @Binding var mysourceType: UIImagePickerController.SourceType
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context:
                                UIViewControllerRepresentableContext<A>) {
    }
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<A>) -> UIImagePickerController {
        
        let obj = UIImagePickerController()
        obj.sourceType = mysourceType
        obj.delegate = context.coordinator
        return obj
    }
            
            func makeCoordinator() -> C {
                return C(isShown: $isShown, myimage: $myimage)
            }
        }




class C:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isShown: Bool
    @Binding var myimage: Image
    init(isShown: Binding<Bool>, myimage: Binding<Image>)
    {
        _isShown = isShown
        _myimage = myimage
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            myimage = Image.init (uiImage: image)
        }
        isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
/*
import SwiftUI
import UIKit
struct ImagePicker: View {
    @State private var isShown: Bool = false
    @State private var image: Image =
    Image(systemName: "")
    
    @State private var sourceType:
    UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack{
            image.resizable()
                .frame (width: 300, height: 200)
            
            Button(
                action: {
                    self.isShown.toggle()
                    self.sourceType = .camera
                })
            {
                Text("Camera" ).padding()
            }
            
            Button(
                action: {
                    self.isShown.toggle()
                    self.sourceType = .photoLibrary
                })
            {
                Text ("Gallery")
            }
            
            Button (
                action: {
                    self.isShown.toggle()
                    self.sourceType = .savedPhotosAlbum
                })
            {
                Text ("album")
            }
        } .sheet(isPresented: $isShown) {
            A(isShown: $isShown, myimage: self.$image, mysourceType: self.$sourceType)
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker()
    }
}
struct A: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var myimage: Image
    @Binding var mysourceType: UIImagePickerController.SourceType
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context:
                                UIViewControllerRepresentableContext<A>) {
    }
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<A>) -> UIImagePickerController {
        
        let obj = UIImagePickerController()
        obj.sourceType = mysourceType
        obj.delegate = context.coordinator
        return obj
    }
            
            func makeCoordinator() -> C {
                return C(isShown: $isShown, myimage: $myimage)
            }
        }




class C:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isShown: Bool
    @Binding var myimage: Image
    init(isShown: Binding<Bool>, myimage: Binding<Image>)
    {
        _isShown = isShown
        _myimage = myimage
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            myimage = Image.init (uiImage: image)
        }
        isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
*/
