
Pod::Spec.new do |spec|


  spec.name         = "EiteiQR"
  spec.version      = "0.0.1"
  spec.summary      = "A QR Code Scanner developed by Eitei."

  spec.description  = <<-DESC
                    A new generation of QR Code Scanner developed by Eitei.
                   DESC
  spec.homepage     = "https://github.com/JunEitei/EiteiQRScanner"

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Huang Jun" => "dadada.maomaomao@gmail.com" }

  spec.platform     = :ios, '13.0'
  spec.swift_version = "5.7"

  spec.source       = { :git => "https://github.com/JunEitei/EiteiQRScanner.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*"

end
