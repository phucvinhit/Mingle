//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Vinh Pham on 9/1/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    var weatherServiceTest: WeatherService!
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        weatherServiceTest = WeatherService()
        sessionUnderTest = URLSession.shared
        
//         Setup test parser data
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "WeatherDataTest", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?id=1566083&cnt=6&APPID=fcb03c17ab6bb5606920752f712561de&units=metric")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        weatherServiceTest.defaultSession = sessionMock
    }

    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    //MARK: Test function call service
    func testCallToOpenWeather() {
    
        //Test case fail if time out faster currently: 5
        let cityCode = "2950158"
        
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast/daily")
            else { return }
        urlComponents.query = "id=\(cityCode)&cnt=6&APPID=\(WeatherService.APIKey)&units=metric"
         guard let url = urlComponents.url else { return }
    
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testParserDataAfterReceiveData() {
        let promise = expectation(description: "Status code: 200")
        let cityCode = "2950158"
        
        // when
        XCTAssertNil(weatherServiceTest?.weather)
        weatherServiceTest.getWeatherResults(cityCode: cityCode) { (_,_) in
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        // result after call API
        XCTAssertEqual(weatherServiceTest?.weather.list.count, 6, "Did't get full list List object")
    }
    
    // MARK: Test Function internal
    func testGetCitiesFromLocalFile() {
        let cities = CitiesViewModel().getAllCities()
        
        XCTAssertEqual(cities.count, 7, "Did't get enough cities")
    }

}
