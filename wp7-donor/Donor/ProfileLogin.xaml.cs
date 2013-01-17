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

        private void UserLoaded(object sender, EventArgs e)
        {
            DataContext = App.ViewModel;
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

            if ((App.ViewModel.User.FacebookId != "") && (App.ViewModel.User.FacebookId != null))
            {
                this.FacebookLinkingButton.Visibility = Visibility.Collapsed;
                this.FacebookUnLinkingButton.Visibility = Visibility.Visible;
            }
            else
            {
                this.FacebookLinkingButton.Visibility = Visibility.Visible;
                this.FacebookUnLinkingButton.Visibility = Visibility.Collapsed;
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

                            App.ViewModel.User.Password = this.password1.Password.ToString();

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

                            List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                            new FlurryWP7SDK.Models.Parameter("objectId", App.ViewModel.User.objectId), 
                            new FlurryWP7SDK.Models.Parameter("platform", "wp7") };
                            FlurryWP7SDK.Api.LogEvent("User_register", articleParams);

                            App.ViewModel.SaveUserToStorage();

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

        private MessagePrompt messagePrompt;
        private void RestorePassword_Click(object sender, RoutedEventArgs e)
        {
            StackPanel restore = new StackPanel();
            restore.Children.Add(new TextBlock { Text = Donor.AppResources.EnterYourEmailForRestorePassword, TextWrapping = TextWrapping.Wrap });
            restore.Children.Add(new TextBox { Text = "", Name = "RestoreEmail" });
            messagePrompt = new MessagePrompt
            {
                Title = Donor.AppResources.RestorePassword,
                Body = restore,
                IsAppBarVisible = true,
                IsCancelVisible = true
            };
            messagePrompt.Completed += new EventHandler<PopUpEventArgs<string, PopUpResult>>(messagePrompt_Completed);
            messagePrompt.Show();
        }

        /// <summary>
        /// Отправляем запрос на parse.com для востановления пароля
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void messagePrompt_Completed(object sender, PopUpEventArgs<string, PopUpResult> e)
        {
            if (e.PopUpResult == PopUpResult.Ok)
            {
                string _email = ((messagePrompt.Body as StackPanel).Children.FirstOrDefault(c => (c as FrameworkElement).Name == "RestoreEmail") as TextBox).Text.ToString();
                App.ViewModel.User.RestoreUserPassword(_email);
            };
        }

        /// <summary>
        /// show and hide buttons for unlinking and linking after linking account with facebook account finished
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void FacebookLinkingFinished(object sender, EventArgs e)
        {
            this.FacebookLinkingButton.Visibility = Visibility.Collapsed;
            this.FacebookUnLinkingButton.Visibility = Visibility.Visible;
        }

        private void FacebookUnLinkingFinished(object sender, EventArgs e)
        {
            this.FacebookLinkingButton.Visibility = Visibility.Visible;
            this.FacebookUnLinkingButton.Visibility = Visibility.Collapsed;
        }

        private void Pivot_Loaded(object sender, RoutedEventArgs e)
        {
            App.ViewModel.UserEnter += new MainViewModel.UserEnterEventHandler(this.UserLoaded);
            App.ViewModel.User.FacebookLinked += new DonorUser.FacebookLinkedEventHandler(this.FacebookLinkingFinished);
            App.ViewModel.User.FacebookUnLinked += new DonorUser.FacebookUnLinkedEventHandler(this.FacebookUnLinkingFinished);

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
                            if (this.NavigationContext.QueryString.ContainsKey("email"))
                            {
                                string _email = this.NavigationContext.QueryString["email"];
                                this.email.Text = _email;
                            };
                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.LoginForm.Visibility = Visibility.Visible;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Collapsed;
                            break;
                        case "edit":

                            this.EditButton.Visibility = Visibility.Collapsed;
                            this.DeleteUserButton.Visibility = Visibility.Collapsed;

                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Visible;

                            if ((App.ViewModel.User.FacebookId != "") && (App.ViewModel.User.FacebookId != null))
                            {
                                this.FacebookLinkingButton.Visibility = Visibility.Collapsed;
                                this.FacebookUnLinkingButton.Visibility = Visibility.Visible;
                            }
                            else
                            {
                                this.FacebookLinkingButton.Visibility = Visibility.Visible;
                                this.FacebookUnLinkingButton.Visibility = Visibility.Collapsed;
                            };
            
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
            try
            {
                if (App.ViewModel.User.Sex == 1)
                {
                    this.SexEditGroup.SelectedIndex = 1;
                }
                else
                {
                    this.SexEditGroup.SelectedIndex = 0;
                };
            }
            catch { };

            try
            {
                this.BloudTypeGroupEdit.SelectedIndex = App.ViewModel.User.BloodGroup;
            }
            catch { };

            try
            {
                this.RHedit.SelectedIndex = App.ViewModel.User.BloodRh;
            }
            catch { };
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            this.EditProfile.Visibility = Visibility.Visible;

            if ((App.ViewModel.User.FacebookId != "") && (App.ViewModel.User.FacebookId != null))
            {
                this.FacebookLinkingButton.Visibility = Visibility.Collapsed;
                this.FacebookUnLinkingButton.Visibility = Visibility.Visible;
            }
            else
            {
                this.FacebookLinkingButton.Visibility = Visibility.Visible;
                this.FacebookUnLinkingButton.Visibility = Visibility.Collapsed;
            };

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

        /// <summary>
        /// Сохраняем изменения
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveEditProfileButton_Click(object sender, EventArgs e)
        {
            try
            {
                App.ViewModel.User.BloodGroup = this.BloudTypeGroupEdit.SelectedIndex;
            }
            catch { };

            try
            {
                App.ViewModel.User.Sex = this.SexEditGroup.SelectedIndex;
            }
            catch { };

            try
            {
                App.ViewModel.User.BloodRh = this.RHedit.SelectedIndex;
            }
            catch { };

            try
            {
                App.ViewModel.User.Name = this.EditName.Text;
                App.ViewModel.User.SecondName = this.EditSecondName.Text;
            }
            catch
            {
            };

            App.ViewModel.User.UpdateAction(null);

            this.EditProfile.Visibility = Visibility.Collapsed;

            this.CancelEditProfileButton.Visibility = Visibility.Collapsed;
            this.SaveEditProfileButton.Visibility = Visibility.Collapsed;

            this.EditButton.Visibility = Visibility.Visible;
            this.DeleteUserButton.Visibility = Visibility.Visible;

            this.RegisterForm.Visibility = Visibility.Collapsed;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Visible;

        }

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

        private void DeleteUserButton_Click(object sender, EventArgs e)
        {
            App.ViewModel.User.LogoutAction(null);
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            string username = this.email.Text;
            string password = this.password.Password;

            this.email.Text = "";
            this.password.Password = "";

            App.ViewModel.User.UserName = username;
            App.ViewModel.User.Password = password;

            App.ViewModel.User.LoginAction(null);
        }

        /// <summary>
        /// Вход через facebook
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void FacebookLogin_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        /// <summary>
        /// Связываем или отвязываем профиль facebook
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void FacebookLinkingButton_Click(object sender, RoutedEventArgs e)
        {
            if ((App.ViewModel.User.IsLoggedIn) && (App.ViewModel.User.FacebookToken != "") && (App.ViewModel.User.FacebookId != "") && (App.ViewModel.User.FacebookToken != null) && (App.ViewModel.User.FacebookId != null))
            {
                App.ViewModel.User.FacebookLinking(App.ViewModel.User.FacebookId, App.ViewModel.User.FacebookToken);
            }
            else
            {
                try
                {
                    NavigationService.Navigate(new Uri("/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
                }
                catch
                {
                };
            };
        }

        private void FacebookUnLinkingButton_Click(object sender, RoutedEventArgs e)
        {
            App.ViewModel.User.FacebookUnlinking();
        }

        private void email1_TextChanged(object sender, TextChangedEventArgs e)
        {
        }

        private void email1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                this.password1.Focus();
            };
        }

        private void password1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                this.password2.Focus();
            };
        }

        private void password2_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                this.name1.Focus();
            };
        }

        private void SecondNameRegister_KeyDown(object sender, KeyEventArgs e)
        {
        }

        private void name1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                this.SecondNameRegister.Focus();
            };
        }

        private void email_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                this.password.Focus();
            };
        }

        private void EditName_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                this.EditSecondName.Focus();
            };            
        }

        private void TextBlock_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            RestorePassword_Click(sender, null);
        }

    }
}