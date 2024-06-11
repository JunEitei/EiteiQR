
Pod::Spec.new do |spec|


  spec.name         = "EiteiQRScanner"
  spec.version      = "1.0.0"
  spec.summary      = "A QR Code Framework developed by Eitei."

  spec.description  = <<-DESC
                    A new generation of QR Code Scanner developed by Eitei.
                   DESC
  spec.homepage     = "https://github.com/JunEitei/EiteiQRScanner"

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Damao" => "jun.huang@eitei.co.jp" }

  spec.platform     = :ios, '13.0'
  spec.swift_version = "5.7"

  spec.source       = { :git => "https://github.com/JunEitei/EiteiQRScanner.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*"

end