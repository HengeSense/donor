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
using Donor.ViewModels;
using System.Text;
using System.Diagnostics;
using RestSharp;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Donor
{
    public partial class ProfileLogin : PhoneApplicationPage
    {
        public ProfileLogin()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var user = new DonorUser { UserName = "test", Password = "test" };
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/login", Method.GET);
            //request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();
            string strJSONContent = "{\"username\":\"" + this.email.Text + "\",\"password\":\"" + this.password.Password + "\"}";
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");

            request.AddParameter("username", this.email.Text);
            request.AddParameter("password", this.password.Password);

            client.ExecuteAsync(request, response =>
            {
                //MessageBox.Show(response.Content.ToString());
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {
                    App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                    App.ViewModel.User.IsLoggedIn = true;
                }
                else
                {
                    MessageBox.Show("Ошибка входа: " + o["error"].ToString());
                    App.ViewModel.User.IsLoggedIn = false;
                };
            });

            /*var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/users", Method.POST);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();
            string strJSONContent = "{\"username\":\""+this.email.Text+"\",\"password\":\"" + this.password.Password + "\"}";
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");
            request.AddHeader("Content-Type", "application/json");

            request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

            client.ExecuteAsync(request, response => {
                MessageBox.Show(response.Content.ToString());
            });*/
        }

        void webClient_UploadStringCompleted(object sender, UploadStringCompletedEventArgs e)
        {
            Debug.WriteLine("completed");
            try
            {
                MessageBox.Show(e.Result.ToString());
            }
            catch
            {
            };
        }
    }
}