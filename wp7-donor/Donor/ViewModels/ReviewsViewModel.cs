using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using RestSharp;
using System.Collections.ObjectModel;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.ComponentModel;
using System.Linq;

namespace Donor.ViewModels
{
    public class ReviewsListViewModel : INotifyPropertyChanged
    {
        public ReviewsListViewModel()
        {
            this.Items = new ObservableCollection<ReviewsViewModel>();
        }

        public delegate void ReviewsLoadedEventHandler(object sender, EventArgs e);
        public event ReviewsLoadedEventHandler ReviewsLoaded;
        protected virtual void OnReviewsLoaded(EventArgs e)
        {
            if (ReviewsLoaded != null)
                ReviewsLoaded(this, e);
        }

        /// <summary>
        /// Загружаем список отзывов о станции, с идентификатором,
        /// соответствующим первому параметру
        /// </summary>
        /// <param name="StationId">
        /// Идентификатор переливания станции
        /// </param>
        public void LoadReviewsForStation(string StationId)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/StationReviews", Method.GET);
            request.Parameters.Clear();
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

            request.AddBody("where={\"station_nid\":" + StationId.ToString() + "}\norder=-createdTimestamp");

            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<ReviewsViewModel> reviewslist1 = new ObservableCollection<ReviewsViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    reviewslist1 = JsonConvert.DeserializeObject<ObservableCollection<ReviewsViewModel>>(o["results"].ToString());
                    var reviewslist2 = (from reviews in reviewslist1
                                        orderby reviews.CreatedTimestamp descending
                                        select reviews);
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Items = new ObservableCollection<ReviewsViewModel>(reviewslist2);
                        this.NotifyPropertyChanged("Items");
                        
                        this.OnReviewsLoaded(EventArgs.Empty);
                    });
                }
                catch
                {
                };
                
            });
            this.NotifyPropertyChanged("Items");
            //this.OnReviewsLoaded(EventArgs.Empty);
            
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public void RaisePropertyChanged(string property)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(property));
            }
        }

        public ObservableCollection<ReviewsViewModel> Items;
    }

    /// <summary>
    /// Единичный отзыв пользователя на станцию переливания
    /// </summary>
    public class ReviewsViewModel
    {
        public ReviewsViewModel()
        {
        }

        /// <summary>
        /// ObjectID идентификатор пользователя, оставившего комментарий
        /// </summary>
        public string User_id { get; set; }
        /// <summary>
        /// Имя пользователя
        /// </summary>
        public string Username
        {
            get;
            set;
        }
        /// <summary>
        /// ObjectID идентификатор станции, к которому был оставлен комментарий (отзыв) пользователя
        /// </summary>
        public string Station_id { get; set; }
        /// <summary>
        /// Текст отзыва к станции
        /// </summary>
        public string Body { get; set; }
        /// <summary>
        /// Оценка станции, от 1 до 5
        /// </summary>
        public int Vote { get; set; }

        public string ShortDateText
        {
            private set { }
            get
            {
                try
                {
                    DateTime created = DateTime.Parse(this.Created);
                    return created.ToShortDateString();
                }
                catch {
                    return DateTime.Now.ToShortDateString();
                };
            }
        }

        /// <summary>
        /// - оценка регистратуры станции, от 1 до 5
        /// </summary>
        public int Vote_registry { get; set; }
        /// <summary>
        /// - оценка врача-терапевта станции, от 1 до 5
        /// </summary>
        public int Vote_physician { get; set; }
        /// <summary>
        /// - оценка лаборатории станции, от 1 до 5
        /// </summary>
        public int Vote_laboratory { get; set; }
        /// <summary>
        /// - оценка буфета станции, от 1 до 5
        /// </summary>
        public int Vote_buffet { get; set; }
        /// <summary>
        /// - оценка расписания работы станции, от 1 до 5
        /// </summary>
        public int Vote_schedule { get; set; }
        /// <summary>
        /// - оценка организации сдачи крови, (кроводачи), от 1 до 5
        /// </summary>
        public int Vote_organization_donation { get; set; }
        /// <summary>
        /// - оценка помещения станции переливания, от 1 до 5
        /// </summary>
        public int Vote_room { get; set; }

        public string UpdatedAt { get; set; }
        public string CreatedAt { get; set; }

        public Int64 Nid { get; set; }
        public Int64 Station_nid { get; set; }

        public DateTime Date { get; set; }

        public string Created { get; set; }
        public Int64 CreatedTimestamp { get; set; }
    }

}
