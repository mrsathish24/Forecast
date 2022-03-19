//
//  ViewController.swift
//  ForecastTask
//
//  Created by Rifluxyss on 19/03/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var forecastDetails: Forecasts?
    
    private let headerId = "forecatHeaderId"
    private let cellId = "forecatCellId"
    
    lazy var tableView: UITableView = {
        let forecatTableView = UITableView(frame: .zero, style: .plain)
        forecatTableView.translatesAutoresizingMaskIntoConstraints = false
        forecatTableView.backgroundColor = .white
        forecatTableView.delegate = self
        forecatTableView.dataSource = self
        forecatTableView.register(ForecastCustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
        forecatTableView.register(ForecastCustomTableCell.self, forCellReuseIdentifier: self.cellId)
        return forecatTableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getForecastData()
        
        view.addSubview(tableView)
        setupAutoLayout()
    }
    
    func getForecastData() {
        if let json = kForecastsData {
            forecastDetails = json
            self.tableView.reloadData()
        } else {
            Connection.shared.getForecastJson(completion: {(json) in
                print(json.forecast.forecastday.count)
                kForecastsData = json
                self.forecastDetails = json
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func setupAutoLayout() {
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ForecastCustomTableViewHeader
        header.countryLabel.text = forecastDetails?.location.country
        header.cityLabel.text = forecastDetails?.location.name
        header.dateAndTimeLabel.text = forecastDetails?.location.localtime
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDetails?.forecast.forecastday.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ForecastCustomTableCell
        
        let forecastDate = forecastDetails?.forecast.forecastday[indexPath.row].date ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: forecastDate)
        cell.textLabel?.text = date?.getFormattedDate(format: "EEEE")
        
        let url = URL(string:("https:\(forecastDetails?.forecast.forecastday[indexPath.row].day.condition.icon ?? "")"))
        if let data = try? Data(contentsOf: url!) {
            cell.imageView?.image = UIImage(data: data)!
        }
        
        let minTemp = forecastDetails?.forecast.forecastday[indexPath.row].day.mintemp_c.toString
        let maxTemp = forecastDetails?.forecast.forecastday[indexPath.row].day.maxtemp_c.toString
        cell.minTempLabel.text = "\(minTemp ?? "0")C"
        cell.maxTempLabel.text = "\(maxTemp ?? "0")C"
        
        return cell
    }
}

class ForecastCustomTableViewHeader: UITableViewHeaderFooterView {
    var countryLabel: UILabel!
    var cityLabel: UILabel!
    var dateAndTimeLabel: UILabel!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .blue
        contentView.layer.cornerRadius = 15.0
        
        countryLabel = UILabel(frame: CGRect(x: self.frame.width + 150, y: self.frame.height + 20, width: 100.0, height: 40))
        countryLabel.textColor = UIColor.white
        countryLabel.font = UIFont.boldSystemFont(ofSize: 29.0)
        
        cityLabel = UILabel(frame: CGRect(x: self.frame.width + 150, y: 50, width: 100.0, height: 40))
        cityLabel.textColor = UIColor.white
        
        dateAndTimeLabel = UILabel(frame: CGRect(x: self.frame.width + 100, y: 120, width: 250.0, height: 40))
        dateAndTimeLabel.textColor = UIColor.white
        dateAndTimeLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        addSubview(countryLabel)
        addSubview(cityLabel)
        addSubview(dateAndTimeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ForecastCustomTableCell: UITableViewCell {
    var maxTempLabel: UILabel!
    var minTempLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .green
        contentView.layer.cornerRadius = 15.0
        
        minTempLabel = UILabel(frame: CGRect(x: self.frame.width - 80, y: self.frame.height/2, width: 100.0, height: 40))
        minTempLabel.textColor = UIColor.black
        
        maxTempLabel = UILabel(frame: CGRect(x: self.frame.width, y: self.frame.height/2, width: 100.0, height: 40))
        maxTempLabel.textColor = UIColor.black

        addSubview(minTempLabel)
        addSubview(maxTempLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
