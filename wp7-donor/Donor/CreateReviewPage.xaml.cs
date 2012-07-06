﻿using System;
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
            string strJSONContent = "{\"username\":\"" + App.ViewModel.User.Name.ToString() + "\",\"user_id\":\"" + App.ViewModel.User.objectId.ToString() + "\",\"station_id\":\"" + _stationid_current.ToString() + "\",\"body\":\"" + this.Body.Text.ToString() + "\", \"vote\":" + this.Vote.Text.ToString() + "}";
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");
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