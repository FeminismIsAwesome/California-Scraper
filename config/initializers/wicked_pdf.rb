if(Rails.env == 'production')
	WickedPdf.config = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => Rails.root.to_s + '/bin/wkhtmltopdf'
	}
else
	WickedPdf.config = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => '/usr/local/bin/wkhtmltopdf'
	}
end

