require 'httparty_with_cookies'
require 'securerandom'

class PortalAPI
  include HTTParty
  base_uri 'https://t1agency.wrg-ins.com/pc/service/edge/gateway/'
  http_proxy('127.0.0.1', 8888)
  attr_reader :last_resp

  def initialize(browser)
    @browser = browser
    _get_cookies
    #@browser.close
  end

  #{"country":"US","contactType":"company","contactName":"Test Agency JDS #3"}

  def get_potential_existing_accounts(contact_name, contact_type = 'company', country = 'US')
    params = { "country" => country, "contactType" => contact_type, "contactName" => contact_name}
    _account_rpc('getPotentialExistingAccounts', params)
  end

  def _account_rpc(method, params)
    _rpc_call('/account', method, params)
  end

  def _get_cookies
    @browser.goto('https://t1agency.wrg-ins.com/portal/html/')
    binding.pry
    @browser.cookies.to_a.each { |c| self.class.cookies[c[:name]] = c[:value] }
  end

  # https://t1agency.wrg-ins.com/portal/html/
  def questions
    self.class.get("/2.2/questions", @options)
  end

  def users
    self.class.get("/2.2/users", @options)
  end

  def pry
    binding.pry
    resp = get_potential_existing_accounts('Test Agency JDS #3')
    STDOUT.puts
  end

  def _rpc_call(endpoint, method, params)
    opts =  _rpc_opts(method, params)
    @last_resp = self.class.post(endpoint, opts)
    raise "Non 200 response (#{@last_resp.code}) in _rpc_call" unless @last_resp.code == 200
    JSON.load(@last_resp.body)['result']
  end

  def _rpc_opts(method, params)
    {
      headers: _default_headers,
      verify: false,
      body:
      {
          "id" =>"#{SecureRandom.uuid}",
          "jsonrpc" =>"2.0",
          "method" =>"#{method}",
          "params" => [params]
      }.to_json
    }
  end

  def _default_headers
    {
    'Sec-Fetch-Mode' => 'cors',
    'Origin' => 'https://t1agency.wrg-ins.com',
    'Accept-Language' => 'en_US',
    'SelectedUsername' => 'qa1_uw',
    'SelectedAgencyCode' => '130055',
    'Content-Type' => 'application/json; charset=utf-8',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImtleS1pZC0xIiwidHlwIjoiSldUIn0.eyJqdGkiOiIxMDc3NWJiZTFiYTg0M2NjYmQ4ODQ1NTAyN2RmMTlhNCIsIm5vbmNlIjoiRE9rNW5hVVJ1aENlTmdWdCIsInN1YiI6IjU0ODZhZDk0LWMzNTYtNDQ5ZC1hMDExLTJlMmNjNmE3Y2IxYiIsInNjb3BlIjpbIm9wZW5pZCJdLCJjbGllbnRfaWQiOiJnYXRld2F5LXBvcnRhbCIsImNpZCI6ImdhdGV3YXktcG9ydGFsIiwiYXpwIjoiZ2F0ZXdheS1wb3J0YWwiLCJ1c2VyX2lkIjoiNTQ4NmFkOTQtYzM1Ni00NDlkLWEwMTEtMmUyY2M2YTdjYjFiIiwib3JpZ2luIjoiYWRmcy1sb2NhbCIsInVzZXJfbmFtZSI6IlFBMV9VVyIsImVtYWlsIjoiV1JHRENUTUB3cmctaW5zLmNvbSIsImF1dGhfdGltZSI6MTU2OTk1MjUwMywicmV2X3NpZyI6ImM0Y2M1NDc5IiwiaWF0IjoxNTY5OTUyNTA0LCJleHAiOjE1Njk5NTYxMDQsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC91YWEvb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsiZ2F0ZXdheS1wb3J0YWwiLCJvcGVuaWQiXX0.t4yaxyA54lSZJgMzExb8MJ38SX7kVUOrgZ7dLsnW-FzYWM8rQ1YuG2xc9dHdZZlT2QPOYJndgnsj9tLGsMfdbprX1DHH_GCZP4veRkhUlA0gzufjm1SmZCXwWKHBnZwp4UXTcn-H8CXdFcq4YNhyQ0tn_5y4mVX3EUp8gjgmIB_vP19OVHeHjnDlQ6G11Fb6CSaod9Vu5M810kRtP-M_2AOmrPghpP3h6O77dhSx-V7Z0XUrJYMoYFBaVvsoFZO6X06L6dg6wIjHIh3gRzc2m9PoYRtIyEQHt00LpctF2zidP8vmTpjDY9-jY7ORV__ePQtWWxZOQOskdhM0sf5b1A',
    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36',
    'Sec-Fetch-Site' => 'same-origin',
    'Referer' => 'https://t1agency.wrg-ins.com/portal/html/index.html',
    'Accept-Encoding' => 'gzip, deflate, br',
    }
  end

end