require 'json'

class Employee
  EMPLOYEE_DATA_PATH = './data/employee.json'

  def self.push(name, designation)
    employee_detail = {'id' => get_employeeid,
                       'name' => name,
                       'designation' => designation}
    employee_details = get_employee_details
    employee_details.push(employee_detail)

    file = File.open(EMPLOYEE_DATA_PATH)
    file.puts(JSON.pretty_generate(employee_details))
  end

  def self.get_employee_details
    employee_details = []
    file = File.read(EMPLOYEE_DATA_PATH)
    employee_details = JSON.parse(file)
  end

  def self.get_employeeid
    employee_details = get_employee_details
    if employee_details.last.nil?
      1
    else
      employee_details.last['id'] + 1
    end
  end
end
