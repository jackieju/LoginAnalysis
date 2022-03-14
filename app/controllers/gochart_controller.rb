require 'csv'
class GochartController < ApplicationController
    protect_from_forgery :except => :index
    def index
        file = params[:file] #上传的key名为file
            puts "@file #{file}"
            # {"file"=>#<ActionDispatch::Http::UploadedFile:0x00007f3bf09cc510 @tempfile=#<Tempfile:/tmp/RackMultipart20210807-28560-1ld7wxc.txt>, @original_filename="ip1000_v1_res_uniq.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"file\"; filename=\"ip1000_v1_res_uniq.txt\"\r\nContent-Type: text/plain\r\n">}
            puts "original_filename #{file.original_filename}"
            puts "basename #{File::basename(file.original_filename)}"
            puts "size11 #{	(File::size(file.tempfile).to_f/1024/1024)}mb" #@size11 0.00013637542724609375mb
            puts "zise22 #{file.size}" 
            if  file.size.blank? || !File.extname(file.original_filename).downcase.in?([".csv"])
              render(json:{msg:"file is empty! or is not csv"})
              return
            end
         #   filename = uploadfile(file)
          #  puts "filename:#{filename}"
#            render(json:{msg:"ok"})
            str = file.read
            table = CSV.parse(str, headers:true)
             p table[20][0].inspect
              @min = DateTime.new(3000, 1,1)
            @data = convert(table)
            @min = @min.strftime("%Y-%m-%d %H:%M:%S")
           
           # print @data.inspect
          #  @data = '[{"machine":"Renee.Pan","startTime":null,"endTime":"Mar 7, 2022 @ 16:47:08.813"}]'.html_safe
      #  render :plain=>"ok"+"#{str}"
      render :layout => false, :template=>"gochart/index1"
    end
    
    def parseTime(t)
        print "parse time:#{t}\n"
        if (t == nil || t == "-")
            return 0
        end
        tt = DateTime.parse(t, "%b %e,%Y @ %H:%M:%S")
        if tt < @min
            @min = tt
        end
        tt.strftime("%Y-%m-%d %H:%M:%S")
    end
    def convert(data)
        # LoginTime,LogoffTime,UserName,DomainName,IP,备注
        # "Mar 8, 2022 @ 00:00:02.493","Mar 8, 2022 @ 08:09:33.262",bin.zeng,VERSACE,10.86.9.130,
        d = []
      
        data.each{|row|
            if row[0] && row[0] == '-'
                next
            end
            if row[0] 
                st = parseTime(row[0])
            else
                st = 0 
            end
            if row["LogoffTime"]
                et = parseTime(row["LogoffTime"])
            else
                et = 0 
            end
            d.push({
                :machine=>row["UserName"],
                :startTime=>st,
                :endTime=>et
            })
        }
        return d.to_json.html_safe
    end
   # def uploadfile(file)
   #     if !file.original_filename.empty?
   #       dir_path = get_upload_dir_path
   #       #设置目录路径，如果目录不存在，生成新目录
   #       FileUtils.mkdir_p(dir_path, :mode => 2750) unless File.exist?(dir_path)
   #       #写入文件
   #       ##wb 表示通过二进制方式写，可以保证文件不损坏
   #       filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{file.original_filename}"
   #       filename_path = dir_path + filename
   #       File.open(filename_path, "wb") do |f|
   #         f.write(file.read)
   #       end
   #       return filename
   #     end
   #   end
   #
      # 上传文件的目录
     # def get_upload_dir_path(upload_file_path = "/public/upload/category_statistics/")
     #   @upload_file_path = "#{Rails.root}#{upload_file_path}"
     # end

end
