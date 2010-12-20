require 'environment'

error_logger = Logger.new('log/errors.log')

error do
  e = request.env['sinatra.error']
  info = "#{Time.now.to_s(:db)} -- Application error\n#{e}\n#{e.backtrace.join("\n")}"

  error_logger.info info
  Kernel.puts info

  'Application error'
end

get '/' do
  page = `curl --silent '#{CFG['url']}'`
  doc = Nokogiri::HTML(page)
  service_name = 'NOT_FOUND'

  doc.css('body > table').each_with_index do |service,i|
    # 0 -> meta, odd -> name, even -> data
    next if i == 0
    if i.odd?
      service_name = service.css('th a')[1].content
      next
    end

    (service.css('tr')[2..-1]||[]).each do |server|
      name = server.css('td')[0]
      server_name = name.content
      next if ['Backend','Frontend'].include?(server_name)

      is_off = (server.attr('class') == 'maintain')
      todo = (is_off ? 'enable' : 'disable')

      name.inner_html = "#{server_name} <a href='/set?todo=#{todo}&amp;service=#{service_name}&amp;server=#{server_name}'>#{todo}</a>"
    end
  end
  doc.to_s
end

get '/set' do
  result = `sudo #{File.expand_path('ha_switch')} #{params[:todo]} #{params[:service]} #{params[:service]} 2>&1`
  if $?.success?
    redirect '/'
  else
    "ERROR #{result}"
  end
end

# users trying to use the normal ha should be redirected
get '/haproxy' do
  redirect '/'
end