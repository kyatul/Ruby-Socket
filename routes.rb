require_relative 'employee'

class Routes
  ALL_EMPLOYEE_PATH = './public/all_employees.html'

  def self.response(method, path)
    if method == 'POST' && path == '/add_employee.html'

    elsif path.eql?(ALL_EMPLOYEE_PATH)
      response = ''
      employee_details = Employee.get_employee_details

      employee_details.each do |employee_detail|
        response << "Name #{employee_detail['name']}\n"
        response << "Designation #{employee_detail['designation']}\n\n"
      end
      return response, '200 OK'
    else
      puts "1"
      file = File.open(path)
      size = file.size
      response = IO.read(file)

      return response, '200 OK'
    end
  end
end
