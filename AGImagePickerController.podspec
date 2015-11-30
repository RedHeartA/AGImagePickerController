Pod::Spec.new do |s|
  s.name         = "AGImagePickerController"
  s.version      = "3.0.0"
  s.summary      = "AGImagePickerController is a image picker controller that allows you to select multiple photos and can be used for all iOS devices."
  s.homepage     = "https://github.com/SpringOx/AGImagePickerController"
  s.license      = 'MIT'
  s.author       = { "SpringOx" => "jiachunke@gmail.com" }
  s.source       = { :git => "https://github.com/SpringOx/AGImagePickerController.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = 'AGImagePickerController/*.{h,m}'
  s.resources    = 'AGImagePickerController/AGImagePickerController.bundle'
  s.framework    = 'AssetsLibrary'
  s.requires_arc = true
end
