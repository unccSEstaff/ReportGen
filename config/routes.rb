CodecademyScraper::Application.routes.draw do
  root to: "students#index"
  get "/caps_:time", to: "scraper#process_students", as: "caps", defaults: {time: Time.now.getlocal.strftime("%m-%d-%Y_%H-%M-%S")}
  resources :students
end
