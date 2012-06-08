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

            DataContext = App.ViewModel;
            if (App.ViewModel.User.IsLoggedIn == true)
            {
                this.RegisterForm.Visibility = Visibility.Collapsed;
                this.LoginForm.Visibility = Visibility.Collapsed;
                this.UserProfile.Visibility = Visibility.Visible;
            }
            else
            {
                this.RegisterForm.Visibility = Visibility.Collapsed;
                this.LoginForm.Visibility = Visibility.Visible;
                this.UserProfile.Visibility = Visibility.Collapsed;
            };
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var user = new DonorUser { UserName = "test", Password = "test" };
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/login", Method.GET);
            request.Parameters.Clear();
            string strJSONContent = "{\"username\":\"" + this.email.Text + "\",\"password\":\"" + this.password.Password + "\"}";
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");

            request.AddParameter("username", this.email.Text);
            request.AddParameter("password", this.password.Password);

            client.ExecuteAsync(request, response =>
            {
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {
                    App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                    App.ViewModel.User.IsLoggedIn = true;

                    this.RegisterForm.Visibility = Visibility.Collapsed;
                    this.LoginForm.Visibility = Visibility.Collapsed;
                    this.UserProfile.Visibility = Visibility.Visible;

                    this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                    this.ProfileSex.Text = App.ViewModel.User.Sex.ToString();
                    this.ProfileBloodGroup.Text = App.ViewModel.User.BloodGroup.ToString();
                }
                else
                {
                    MessageBox.Show("Ошибка входа: " + o["error"].ToString());
                    App.ViewModel.User.IsLoggedIn = false;

                    this.RegisterForm.Visibility = Visibility.Visible;
                    this.LoginForm.Visibility = Visibility.Collapsed;
                    this.UserProfile.Visibility = Visibility.Collapsed;
                };
            });
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

        private void RegisterButton_Click(object sender, RoutedEventArgs e)
        {
            if (this.password1.Password == this.password2.Password)
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users", Method.POST);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                string strJSONContent = "{\"username\":\"" + this.email1.Text.ToString() + "\",\"password\":\"" + this.password1.Password.ToString() + "\",\"Name\":\"" + this.name1.Text.ToString() + "\"}";
                request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
                request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                client.ExecuteAsync(request, response =>
                {
                    JObject o = JObject.Parse(response.Content.ToString());
                    MessageBox.Show(response.Content.ToString());
                    if (o["error"] == null)
                    {
                        App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                        App.ViewModel.User.IsLoggedIn = true;

                        App.ViewModel.User.Name = this.name1.Text.ToString();
                        App.ViewModel.User.UserName = this.email1.Text.ToString();

                        this.RegisterForm.Visibility = Visibility.Collapsed;
                        this.UserProfile.Visibility = Visibility.Visible;
                        this.LoginForm.Visibility = Visibility.Collapsed;

                        this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                        this.ProfileSex.Text = App.ViewModel.User.Sex.ToString();
                        this.ProfileBloodGroup.Text = App.ViewModel.User.BloodGroup.ToString();
                    }
                    else
                    {
                        MessageBox.Show("Ошибка входа: " + o["error"].ToString());
                        App.ViewModel.User.IsLoggedIn = false;

                        this.RegisterForm.Visibility = Visibility.Visible;
                        this.LoginForm.Visibility = Visibility.Collapsed;
                        this.UserProfile.Visibility = Visibility.Collapsed;
                    };
                });
            }
            else
            {
            };
        }
    }
}