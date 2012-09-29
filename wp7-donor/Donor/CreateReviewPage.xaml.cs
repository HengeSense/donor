using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Newtonsoft.Json.Linq;
using RestSharp;

namespace Donor
{
    public partial class CreateReviewPage : PhoneApplicationPage
    {
        public CreateReviewPage()
        {
            InitializeComponent();
        }

        private void SaveButton_Click(object sender, EventArgs e)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/StationReviews", Method.POST);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();

            int vote = 0;
            int vote_count = 0;
            if (this.vote_registry.Vote != 0)
            {
                vote = this.vote_registry.Vote;
                vote_count++;
            };
            if (this.vote_physician.Vote != 0)
            {
                vote = this.vote_physician.Vote;
                vote_count++;
            };
            if (this.vote_laboratory.Vote != 0)
            {
                vote = this.vote_laboratory.Vote;
                vote_count++;
            };
            if (this.vote_buffet.Vote != 0)
            {
                vote = this.vote_buffet.Vote;
                vote_count++;
            };
            if (this.vote_schedule.Vote != 0)
            {
                vote = this.vote_schedule.Vote;
                vote_count++;
            };
            if (this.vote_organization_donation.Vote != 0)
            {
                vote = this.vote_organization_donation.Vote;
                vote_count++;
            };
            if (this.vote_room.Vote != 0)
            {
                vote = this.vote_room.Vote;
                vote_count++;
            };

            string strJSONContent = "{\"username\":\"" + App.ViewModel.User.Name.ToString() + "\",\"user_id\":\"" + App.ViewModel.User.objectId.ToString() + "\",\"station_id\":\"" + _stationid_current.ToString() + "\",\"body\":\"" + this.Body.Text.ToString() + "\", \"vote\":" + vote.ToString() + ", \"vote_registry\":" + this.vote_registry.Vote.ToString() + ", \"vote_physician\":" + this.vote_physician.Vote.ToString() + ", \"vote_laboratory\":" + this.vote_laboratory.Vote.ToString() + ", \"vote_buffet\":" + this.vote_buffet.Vote.ToString() + ", \"vote_schedule\":" + this.vote_schedule.Vote.ToString() + ", \"vote_organization_donation\":" + this.vote_organization_donation.Vote.ToString() + ", \"vote_room\":" + this.vote_room.Vote.ToString() + "}";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

            client.ExecuteAsync(request, response =>
            {
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {
                    MessageBox.Show("Отзыв добавлен.");
                }
                else
                {
                    MessageBox.Show("Не удалось добавить отзыв");
                };

                NavigationService.GoBack();
            });
            //NavigationService.GoBack();
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            NavigationService.GoBack();
        }

        private string _stationid_current;
        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (App.ViewModel.User.IsLoggedIn == true)
            {
                if (this.NavigationContext.QueryString.ContainsKey("id"))
                {
                    try
                    {
                        string _id = this.NavigationContext.QueryString["id"];
                        _stationid_current = _id;
                    }
                    catch
                    {
                        NavigationService.GoBack();
                    };
                }
                else
                {
                    NavigationService.GoBack();
                };
            }
            else
            {
                NavigationService.GoBack();
            };
        }
    }
}