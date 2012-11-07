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
using Coding4Fun.Phone.Controls;

namespace Donor
{
    public partial class ProfileLogin : PhoneApplicationPage
    {
        public ProfileLogin()
        {
            InitializeComponent();

            DataContext = App.ViewModel;
            this.UpdateUserInfoView();

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


            /*if (App.ViewModel.Settings.Password)
            {
                this.PasswordCheck.IsChecked = true;
            }
            else
            {
                this.PasswordCheck.IsChecked = false;
            };

            if (App.ViewModel.Settings.Push)
            {
                this.PushCheck.IsChecked = true;
            }
            else
            {
                this.PushCheck.IsChecked = false;
            };

            if (App.ViewModel.Settings.FastSearch)
            {
                this.SearchCheck.IsChecked = true;
            }
            else
            {
                this.SearchCheck.IsChecked = false;
            };

            if (App.ViewModel.Settings.EventBefore)
            {
                this.BeforeCheck.IsChecked = true;
            }
            else
            {
                this.BeforeCheck.IsChecked = false;
            };

            if (App.ViewModel.Settings.EventAfter)
            {
                this.AfterCheck.IsChecked = true;
            }
            else
            {
                this.AfterCheck.IsChecked = false;
            };*/

        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            //var user = new DonorUser { UserName = "test", Password = "test" };
        }

        /*
        private void Login_Click(object sender, RoutedEventArgs e)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/login?username=" + Uri.EscapeUriString(this.email.Text.ToString().ToLower()) + "&password=" + Uri.EscapeUriString(this.password.Password), Method.GET);
            request.Parameters.Clear();

            App.ViewModel.User.IsLoggedIn = false;
            
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

            this.LoadingBar.IsIndeterminate = true;

            client.ExecuteAsync(request, response =>
            {
                this.LoadingBar.IsIndeterminate = false;
                try {
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {
                    App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                    App.ViewModel.User.IsLoggedIn = true;                    

                    this.RegisterForm.Visibility = Visibility.Collapsed;
                    this.LoginForm.Visibility = Visibility.Collapsed;
                    this.UserProfile.Visibility = Visibility.Visible;

                    if (App.ViewModel.User.IsLoggedIn == true)
                    {
                        this.AppBar.IsVisible = true;
                    }
                    else
                    {
                        this.AppBar.IsVisible = false;
                    };

                    try
                    {
                        this.UpdateUserInfoView();
                    }
                    catch
                    {
                    };

                    App.ViewModel.Events.LoadEventsParse();
                    App.ViewModel.Events.WeekItemsUpdated();
                }
                else
                {
                    App.ViewModel.User.IsLoggedIn = false;

                    MessageBox.Show("Указаны некорректные данные.");
                };
                } catch {};
            });
        }*/

        private void UserLoaded(object sender, EventArgs e)
        {
            this.LoadingBar.IsIndeterminate = false;

            this.RegisterForm.Visibility = Visibility.Collapsed;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Visible;

            if (App.ViewModel.User.IsLoggedIn == true)
            {
                this.AppBar.IsVisible = true;
            }
            else
            {
                this.AppBar.IsVisible = false;
            };

            try
            {
                this.UpdateUserInfoView();
            }
            catch
            {
            };
        }

        private void RegisterButton_Click(object sender, RoutedEventArgs e)
        {
            if ((this.password1.Password == this.password2.Password) && ((this.CreateMale.IsChecked == true) || (this.CreateFemale.IsChecked == true)) && (this.name1.Text.ToString() != "") && (this.email1.Text.ToString() != ""))
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users", Method.POST);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                int reg_sex = 0;

                if (this.CreateMale.IsChecked == true)
                {
                    reg_sex = 1;
                };

                string strJSONContent = "{\"username\":\"" + this.email1.Text.ToString().ToLower() + "\",\"password\":\"" + this.password1.Password.ToString() + "\", \"birthday\":\"" + this.UserBirthdayRegister.Value.Value.ToShortDateString() + "\", \"Name\":\"" + this.name1.Text.ToString() + "\", \"secondName\":\"" + this.SecondNameRegister.Text.ToString() + "\", \"email\":\"" + this.email1.Text.ToString().ToLower() + "\", \"Sex\":" + reg_sex + "}";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                this.LoadingBar.IsIndeterminate = true;

                client.ExecuteAsync(request, response =>
                {
                    this.LoadingBar.IsIndeterminate = false;
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                            App.ViewModel.User.IsLoggedIn = true;
                            App.ViewModel.Events.WeekItemsUpdated();
                            App.ViewModel.OnUserEnter(EventArgs.Empty);

                            App.ViewModel.User.Name = this.name1.Text.ToString();
                            App.ViewModel.User.SecondName = this.SecondNameRegister.Text.ToString();
                            App.ViewModel.User.Birthday = this.UserBirthdayRegister.Value.Value.ToShortDateString();
                            App.ViewModel.User.UserName = this.email1.Text.ToString();

                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Visible;
                            this.LoginForm.Visibility = Visibility.Collapsed;

                            if (App.ViewModel.User.IsLoggedIn == true)
                            {
                                this.AppBar.IsVisible = true;
                            }
                            else
                            {
                                this.AppBar.IsVisible = false;
                            };

                            try
                            {
                                this.UpdateUserInfoView();
                            }
                            catch
                            {
                            };
                        }
                        else
                        {
                            MessageBox.Show("Не удалось произвести регистрацию.");
                            App.ViewModel.User.IsLoggedIn = false;

                            this.password1.Password = "";
                            this.password2.Password = "";

                            this.RegisterForm.Visibility = Visibility.Visible;
                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                        };
                    }
                    catch {

                        this.password1.Password = "";
                        this.password2.Password = "";

                        App.ViewModel.User.IsLoggedIn = false;
                        this.RegisterForm.Visibility = Visibility.Visible;
                        this.LoginForm.Visibility = Visibility.Collapsed;
                        this.UserProfile.Visibility = Visibility.Collapsed;
                    };
                });
            }
            else
            {
                MessageBox.Show("Проверьте корректность указанных регистрационных данных.");

                this.password1.Password = "";
                this.password2.Password = "";

                App.ViewModel.User.IsLoggedIn = false;
                this.RegisterForm.Visibility = Visibility.Visible;
                this.LoginForm.Visibility = Visibility.Collapsed;
                this.UserProfile.Visibility = Visibility.Collapsed;


            };
        }

        private void UpdateUserInfoView() {
        }

        private MessagePrompt messagePrompt;
        private void RestorePassword_Click(object sender, RoutedEventArgs e)
        {
            StackPanel restore = new StackPanel();
            restore.Children.Add(new TextBlock { Text = "Введите ваш e-mail", TextWrapping = TextWrapping.Wrap });
            restore.Children.Add(new TextBox { Text = "m0rg0t.Anton@gmail.com", Name = "RestoreEmail" });
            messagePrompt = new MessagePrompt
            {
                Title = "Востановление пароля",
                Body = restore,
                IsAppBarVisible = true,
                IsCancelVisible = true
            };
            messagePrompt.Completed += new EventHandler<PopUpEventArgs<string, PopUpResult>>(messagePrompt_Completed);
            messagePrompt.Show();
        }

        void messagePrompt_Completed(object sender, PopUpEventArgs<string, PopUpResult> e)
        {
            string _email = ((messagePrompt.Body as StackPanel).Children.FirstOrDefault(c => (c as FrameworkElement).Name == "RestoreEmail") as TextBox).Text.ToString();

            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/requestPasswordReset", Method.POST);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();
            string strJSONContent = "{\"email\":\"" + _email.ToLower() + "\"}";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddHeader("Content-Type", "application/json");

            request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);
            this.LoadingBar.IsIndeterminate = true;
            client.ExecuteAsync(request, response =>
                {
                    this.LoadingBar.IsIndeterminate = false;
                    JObject o = JObject.Parse(response.Content.ToString());
                    if (o["error"] == null)
                    {

                    }
                    else
                    {

                    };
                });
        }

        private void Pivot_Loaded(object sender, RoutedEventArgs e)
        {
            App.ViewModel.UserEnter += new MainViewModel.UserEnterEventHandler(this.UserLoaded);

            this.AppBar.DataContext = App.ViewModel;
            if (this.NavigationContext.QueryString.ContainsKey("task"))
            {
                try
                {
                    string _taskid = this.NavigationContext.QueryString["task"];
                    switch (_taskid)
                    {
                        case "register":
                            if (this.NavigationContext.QueryString.ContainsKey("email"))
                            {
                                string _email = this.NavigationContext.QueryString["email"];
                                this.email1.Text = _email;
                            };
                            if (this.NavigationContext.QueryString.ContainsKey("password"))
                            {
                                string _password = this.NavigationContext.QueryString["password"];
                                this.password1.Password = _password;
                            };
                            this.RegisterForm.Visibility = Visibility.Visible;
                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Collapsed;
                            break;
                        case "login":
                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.LoginForm.Visibility = Visibility.Visible;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Collapsed;
                            break;
                        case "edit":

                            this.EditButton.Visibility = Visibility.Collapsed;
                            this.DeleteUserButton.Visibility = Visibility.Collapsed;
                            //this.FacebookButton.Visibility = Visibility.Collapsed;
                            //this.FacebookUnlinkingButton.Visibility = Visibility.Collapsed;

                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Visible;

                            this.EditProfile.Visibility = Visibility.Visible;
            
                            this.CancelEditProfileButton.Visibility = Visibility.Visible;
                            this.SaveEditProfileButton.Visibility = Visibility.Visible;

                            SetEditFields();

                            break;
                        default:
                            break;
                    };
                }
                catch
                {
                };
            };

            if (App.ViewModel.User.IsLoggedIn == true)
            {
                this.AppBar.IsVisible = true;
            }
            else
            {
                this.AppBar.IsVisible = false;
            };
        }

        private void SetEditFields() {
            this.EditName.Text = App.ViewModel.User.Name;

            this.EditSecondName.Text = App.ViewModel.User.SecondName;

            //this.EditUserBirthday.Value = App.ViewModel.User.DateBirthday;

            try
            {
                if (App.ViewModel.User.Sex == 1)
                {
                    this.EditFemale.IsChecked = true;
                    this.EditMale.IsChecked = false;
                }
                else
                {
                    this.EditFemale.IsChecked = false;
                    this.EditMale.IsChecked = true;
                };
            }
            catch { };

            try
            {
                switch (App.ViewModel.User.BloodGroup)
                {
                    case 0:
                        this.o.IsChecked = true;
                        this.a.IsChecked = false;
                        this.b.IsChecked = false;
                        this.ab.IsChecked = false;
                        break;
                    case 1:
                        this.o.IsChecked = false;
                        this.a.IsChecked = true;
                        this.b.IsChecked = false;
                        this.ab.IsChecked = false;
                        break;
                    case 2:
                        this.o.IsChecked = false;
                        this.a.IsChecked = false;
                        this.b.IsChecked = true;
                        this.ab.IsChecked = false;
                        break;
                    case 3:
                        this.o.IsChecked = false;
                        this.a.IsChecked = false;
                        this.b.IsChecked = false;
                        this.ab.IsChecked = true;
                        break;
                    default:
                        this.o.IsChecked = false;
                        this.a.IsChecked = false;
                        this.b.IsChecked = false;
                        this.ab.IsChecked = false;
                        break;
                };
            }
            catch { };

            try
            {
                switch (App.ViewModel.User.BloodRh)
                {
                    case 0:
                        this.EditRHpl.IsChecked = true;
                        this.EditRHd.IsChecked = false;

                        break;
                    case 1:
                        this.EditRHpl.IsChecked = false;
                        this.EditRHd.IsChecked = true;
                        break;
                    default:
                        this.EditRHpl.IsChecked = false;
                        this.EditRHd.IsChecked = false;
                        break;
                };
            }
            catch { };
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            this.EditProfile.Visibility = Visibility.Visible;

            this.EditButton.Visibility = Visibility.Collapsed;
            this.DeleteUserButton.Visibility = Visibility.Collapsed;

            this.RegisterForm.Visibility = Visibility.Collapsed;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Collapsed;

            //this.FacebookButton.Visibility = Visibility.Collapsed;
            //this.FacebookUnlinkingButton.Visibility = Visibility.Collapsed;

            

            this.CancelEditProfileButton.Visibility = Visibility.Visible;
            this.SaveEditProfileButton.Visibility = Visibility.Visible;

            SetEditFields();
        }

        private void CancelEditProfileButton_Click(object sender, EventArgs e)
        {
            this.EditProfile.Visibility = Visibility.Collapsed;

            this.CancelEditProfileButton.Visibility = Visibility.Collapsed;
            this.SaveEditProfileButton.Visibility = Visibility.Collapsed;

            this.EditButton.Visibility = Visibility.Visible;
            this.DeleteUserButton.Visibility = Visibility.Visible;

            //this.FacebookButton.Visibility = Visibility.Visible;
            //this.FacebookUnlinkingButton.Visibility = Visibility.Visible;

            this.RegisterForm.Visibility = Visibility.Collapsed;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Visible;
        }

        private void SaveEditProfileButton_Click(object sender, EventArgs e)
        {
            try
            {
                for (int i = 0; i < this.BloudTypeGroupEdit.Children.Count; i++)
                {
                    if (this.BloudTypeGroupEdit.Children[i].GetType().Name == "RadioButton")
                    {
                        RadioButton radio = (RadioButton)this.BloudTypeGroupEdit.Children[i];
                        if ((bool)radio.IsChecked)
                        {
                            App.ViewModel.User.BloodGroup = i;
                        }
                    }
                };
            }
            catch { };

            try
            {
                for (int i = 0; i < this.SexEditGroup.Children.Count; i++)
                {
                    if (this.SexEditGroup.Children[i].GetType().Name == "RadioButton")
                    {
                        RadioButton radio = (RadioButton)this.SexEditGroup.Children[i];
                        if ((bool)radio.IsChecked)
                        {
                            App.ViewModel.User.Sex = i;
                        }
                    }
                };
            }
            catch { };

            try
            {
                for (int i = 0; i < this.SexEditGroup.Children.Count; i++)
                {
                    if (this.RHedit.Children[i].GetType().Name == "RadioButton")
                    {
                        RadioButton radio = (RadioButton)this.RHedit.Children[i];
                        if ((bool)radio.IsChecked)
                        {
                            App.ViewModel.User.BloodRh = i;
                        }
                    }
                };
            }
            catch { };

            try
            {
                App.ViewModel.User.Name = this.EditName.Text;
            }
            catch { };

            try
            {
                App.ViewModel.User.SecondName = this.EditSecondName.Text;
            }
            catch { };

            try
            {
                App.ViewModel.User.Birthday = this.EditUserBirthday.Value.GetValueOrDefault().ToShortDateString();
            }
            catch { };

                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users/" + App.ViewModel.User.objectId.ToString(), Method.PUT);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                string strJSONContent = "{\"Sex\":" + App.ViewModel.User.Sex + ", \"Name\":\"" + App.ViewModel.User.Name + "\", \"secondName\":\"" + App.ViewModel.User.SecondName + "\", \"birthday\": \"" + App.ViewModel.User.Birthday+ "\", \"BloodGroup\":" + App.ViewModel.User.BloodGroup + ", \"BloodRh\":" + App.ViewModel.User.BloodRh + "}";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("X-Parse-Session-Token", App.ViewModel.User.sessionToken);
                request.AddHeader("Content-Type", "application/json");
                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                this.LoadingBar.IsIndeterminate = true;

                client.ExecuteAsync(request, response =>
                {
                    this.LoadingBar.IsIndeterminate = false;
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            MessageBox.Show("Данные профиля обновлены.");
                        }
                        else
                        {
                            MessageBox.Show(response.Content.ToString());
                        };
                    }
                    catch
                    {
                    };
                });

            this.UpdateUserInfoView();

            this.EditProfile.Visibility = Visibility.Collapsed;

            this.CancelEditProfileButton.Visibility = Visibility.Collapsed;
            this.SaveEditProfileButton.Visibility = Visibility.Collapsed;

            this.EditButton.Visibility = Visibility.Visible;
            this.DeleteUserButton.Visibility = Visibility.Visible;

            //this.FacebookButton.Visibility = Visibility.Visible;
            //this.FacebookUnlinkingButton.Visibility = Visibility.Visible;

            this.RegisterForm.Visibility = Visibility.Collapsed;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Visible;

        }


        /// <summary>
        /// Logout user from account and clear saved data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /*private void DeleteUserButton_Click(object sender, EventArgs e)
        {
            App.ViewModel.User.IsLoggedIn = false;

            App.ViewModel.User = new DonorUser();
            App.ViewModel.User.UserName = "";
            App.ViewModel.User.Password = "";

            App.ViewModel.SaveUserToStorage();
            App.ViewModel.Events.UpdateItems();

            NavigationService.GoBack();
        }*/

        private void Check_Checked(object sender, RoutedEventArgs e)
        {
            (sender as ToggleSwitch).Content = "Включено";
            switch ((sender as ToggleSwitch).Name.ToString())
            {
                case "PasswordCheck":
                    App.ViewModel.Settings.Password = true;
                    break;
                case "PushCheck":
                    App.ViewModel.Settings.Push = true;
                    break;
                case "SearchCheck":
                    App.ViewModel.Settings.FastSearch = true;
                    break;
                case "BeforeCheck":
                    App.ViewModel.Settings.EventBefore = true;
                    break;
                case "AfterCheck":
                    App.ViewModel.Settings.EventAfter = true;
                    break;
                default:
                break;
            };
            App.ViewModel.SaveSettingsToStorage();
        }

        private void Check_Unchecked(object sender, RoutedEventArgs e)
        {
            (sender as ToggleSwitch).Content = "Выключено";
            switch ((sender as ToggleSwitch).Name.ToString())
            {
                case "PasswordCheck":
                    App.ViewModel.Settings.Password = false;
                    break;
                case "PushCheck":
                    App.ViewModel.Settings.Push = false;
                    break;
                case "SearchCheck":
                    App.ViewModel.Settings.FastSearch = false;
                    break;
                case "BeforeCheck":
                    App.ViewModel.Settings.EventBefore = false;
                    break;
                case "AfterCheck":
                    App.ViewModel.Settings.EventAfter = false;
                    break;
                default:
                    break;
            };
            App.ViewModel.SaveSettingsToStorage();
        }

        /// <summary>
        /// Shwo register form
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RegisterShowButton_Click(object sender, RoutedEventArgs e)
        {
            this.email1.Text = this.email.Text.ToString();
            this.password1.Password = this.password.Password;

            this.RegisterForm.Visibility = Visibility.Visible;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Collapsed;
        }

        private void FacebookButton_Click(object sender, EventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        private void FacebookUnlinkingButton_Click(object sender, EventArgs e)
        {
            try
            {
                App.ViewModel.User.FacebookUnlinking();
            }
            catch
            {
            };
        }

    }
}