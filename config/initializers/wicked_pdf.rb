if(Rails.env == 'production')
else
	WickedPdf.config = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => '/usr/local/bin/wkhtmltopdf'
	}
end

