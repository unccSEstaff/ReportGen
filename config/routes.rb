ReportGenerator3155::Application.routes.draw do
  root to: "students#index"
  
  get "/caps_:time", to: "codecademy_scraper#process_students", as: "caps", defaults: {time: Time.now.getlocal.strftime("%m-%d-%Y_%H-%M-%S")}
  
  get "/ch4", to: "ch4_walkthrough#index", as: "ch4"
  post "/ch4_:time", to: "ch4_walkthrough#process_students", as: "ch4_report", defaults: {time: Time.now.getlocal.strftime("%m-%d-%Y_%H-%M-%S")}
  
  get "/gitimmersion", to: "gitimmersion#index", as: "gitimmersion"
  post "gitimmersion_:time", to: "gitimmersion#process_students", as: "gitimmersion_report", defaults: {time: Time.now.getlocal.strftime("%m-%d-%Y_%H-%M-%S")}
  
  get "/railstutorial", to: "railstutorial#index", as: "railstutorial"
  post "railstutorial_:time", to: "railstutorial#process_students", as: "railstutorial_report", defaults: {time: Time.now.getlocal.strftime("%m-%d-%Y_%H-%M-%S")}
  resources :students
end
