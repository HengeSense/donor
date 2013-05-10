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
        public string CurrentTask = "";

        public ProfileLogin()
        {
            InitializeComponent();

            DataContext = ViewModelLocator.MainStatic;

            AppBarVisibitilty("");
            CurrentTask = "";
            if (ViewModelLocator.MainStatic.User.IsLoggedIn == true)
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


            /*if (ViewModelLocator.MainStatic.Settings.Password)
            {
                this.PasswordCheck.IsChecked = true;
            }
            else
            {
                this.PasswordCheck.IsChecked = false;
            };

            if (ViewModelLocator.MainStatic.Settings.Push)
            {
                this.PushCheck.IsChecked = true;
            }
            else
            {
                this.PushCheck.IsChecked = false;
            };

            if (ViewModelLocator.MainStatic.Settings.FastSearch)
            {
                this.SearchCheck.IsChecked = true;
            }
            else
            {
                this.SearchCheck.IsChecked = false;
            };

            if (ViewModelLocator.MainStatic.Settings.EventBefore)
            {
                this.BeforeCheck.IsChecked = true;
            }
            else
            {
                this.BeforeCheck.IsChecked = false;
            };

            if (ViewModelLocator.MainStatic.Settings.EventAfter)
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
            DataContext = ViewModelLocator.MainStatic;
            this.LoadingBar.IsIndeterminate = false;

            this.RegisterForm.Visibility = Visibility.Collapsed;
            this.LoginForm.Visibility = Visibility.Collapsed;
            this.UserProfile.Visibility = Visibility.Visible;

            AppBarVisibitilty("");
            if (ViewModelLocator.MainStatic.User.IsLoggedIn == true)
            {
                CurrentTask = "show";
                AppBarVisibitilty("show");
                this.AppBar.IsVisible = true;
            }
            else
            {
                this.AppBar.IsVisible = false;
            };

            if ((ViewModelLocator.MainStatic.User.FacebookId != "") && (ViewModelLocator.MainStatic.User.FacebookId != null))
            {
                this.FacebookLinkingButton.Visibility = Visibility.Collapsed;
                this.FacebookUnLinkingButton.Visibility = Visibility.Visible;
            }
            else
            {
                this.FacebookLinkingButton.Visibility = Visibility.Visible;
                this.FacebookUnLinkingButton.Visibility = Visibility.Collapsed;
            };

            try
            {
                this.Sex = ViewModelLocator.MainStatic.User.Sex;
                this.BloodGroup = ViewModelLocator.MainStatic.User.BloodGroup;
                this.RHEdit = ViewModelLocator.MainStatic.User.BloodRh;
                this.UserDataSet = true;
            }
            catch { };
        }

        private void RegisterButton_Click(object sender, RoutedEventArgs e)
        {
            if ((this.password1.Password == this.password2.Password) && ((this.CreateMale.IsChecked == true) || (this.CreateFemale.IsChecked == true)) && (this.name1.Text.ToString() != "") && (this.email1.Text.ToString() != ""))
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users", Method.POST);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                int reg_sex = 1;

                if (this.CreateMale.IsChecked == true)
                {
                    reg_sex = 0;
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
                            ViewModelLocator.MainStatic.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                            ViewModelLocator.MainStatic.User.IsLoggedIn = true;
                            ViewModelLocator.MainStatic.Events.WeekItemsUpdated();
                            ViewModelLocator.MainStatic.OnUserEnter(EventArgs.Empty);

                            ViewModelLocator.MainStatic.User.Name = this.name1.Text.ToString();
                            ViewModelLocator.MainStatic.User.SecondName = this.SecondNameRegister.Text.ToString();
                            ViewModelLocator.MainStatic.User.Birthday = this.UserBirthdayRegister.Value.Value.ToShortDateString();
                            ViewModelLocator.MainStatic.User.UserName = this.email1.Text.ToString();

                            ViewModelLocator.MainStatic.User.Sex = reg_sex;

                            ViewModelLocator.MainStatic.User.Password = this.password1.Password.ToString();

                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Visible;
                            this.LoginForm.Visibility = Visibility.Collapsed;

                            //ViewModelLocator.MainStatic.OnDataFLoaded(EventArgs.Empty);
                            ViewModelLocator.MainStatic.IsDataLoaded = true;

                            List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                            new FlurryWP7SDK.Models.Parameter("objectId", ViewModelLocator.MainStatic.User.objectId), 
                            new FlurryWP7SDK.Models.Parameter("platform", "wp7") };
                            FlurryWP7SDK.Api.LogEvent("User_register", articleParams);

                            ViewModelLocator.MainStatic.SaveUserToStorage();

                        }
                        else
                        {
                            try {
                                switch (o["code"].ToString())
                                {
                                    case "202":
                                        this.email1.Text = "";
                                        MessageBox.Show("Аккаунт с указанной почтой уже существует.");
                                        break;
                                    default:
                                        MessageBox.Show("Не удалось произвести регистрацию.");
                                        break;
                                };
                            } catch {
                                MessageBox.Show("Не удалось произвести регистрацию."); 
                            };                            
                            ViewModelLocator.MainStatic.User.IsLoggedIn = false;

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

                        ViewModelLocator.MainStatic.User.IsLoggedIn = false;
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

                ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                ViewModelLocator.MainStatic.User.UserLoading = false;
                this.RegisterForm.Visibility = Visibility.Visible;
                this.LoginForm.Visibility = Visibility.Collapsed;
                this.UserProfile.Visibility = Visibility.Collapsed;


            };
        }

        private MessagePrompt messagePrompt;
        private int Sex = 0;
        private int BloodGroup = 0;
        private int RHEdit = 0;
        private bool UserDataSet = false;

        private string passwordsaved = "";
        private string emailsaved = "";

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
                ViewModelLocator.MainStatic.User.RestoreUserPassword(_email);
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

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            try
            {
                emailsaved = this.email1.Text;
                passwordsaved = this.password1.Password;
            }
            catch { };
            base.OnNavigatedFrom(e);
        }


        private void Pivot_Loaded(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.UserEnter += new MainViewModel.UserEnterEventHandler(this.UserLoaded);
            ViewModelLocator.MainStatic.User.FacebookLinked += new DonorUser.FacebookLinkedEventHandler(this.FacebookLinkingFinished);
            ViewModelLocator.MainStatic.User.FacebookUnLinked += new DonorUser.FacebookUnLinkedEventHandler(this.FacebookUnLinkingFinished);

            if (ViewModelLocator.MainStatic.User.IsLoggedIn == true)
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

            this.AppBar.DataContext = ViewModelLocator.MainStatic;
            if (this.NavigationContext.QueryString.ContainsKey("task"))
            {
                try
                {
                    string _taskid = this.NavigationContext.QueryString["task"];
                    if (CurrentTask == "")
                    {
                        CurrentTask = _taskid;
                    };
                    AppBarVisibitilty("");
                    switch (CurrentTask)
                    {
                        case "show":
                            try
                            {
                                this.Sex = ViewModelLocator.MainStatic.User.Sex;
                                this.BloodGroup = ViewModelLocator.MainStatic.User.BloodGroup;
                                this.RHEdit = ViewModelLocator.MainStatic.User.BloodRh;
                                this.UserDataSet = true;
                            }
                            catch { };

                            AppBarVisibitilty("show");
                            break;
                        case "register":
                            this.email1.Text = emailsaved;
                            if ((this.NavigationContext.QueryString.ContainsKey("email")) && (this.emailsaved==""))
                            {
                                string _email = this.NavigationContext.QueryString["email"];
                                this.email1.Text = _email;
                            };
                            this.password1.Password = passwordsaved;
                            if ((this.NavigationContext.QueryString.ContainsKey("password")) && (this.passwordsaved==""))
                            {
                                string _password = this.NavigationContext.QueryString["password"];
                                this.password1.Password = _password;
                            };
                            this.RegisterForm.Visibility = Visibility.Visible;
                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Collapsed;

                            AppBarVisibitilty("register");
                            break;
                        case "login":
                            AppBarVisibitilty("login");
                            ViewModelLocator.MainStatic.User.UserLoading = false;

                            if (this.NavigationContext.QueryString.ContainsKey("email"))
                            {
                                string _email = this.NavigationContext.QueryString["email"];
                                this.email.Text = _email;
                            };
                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.LoginForm.Visibility = Visibility.Visible;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Collapsed;

                            /*this.LoginUserButton.Visibility = Visibility.Visible;
                            this.AppBar.Visibility = Visibility.Visible;*/

                            break;
                        case "edit":
                            try
                            {
                                if (this.UserDataSet == false)
                                {
                                    this.Sex = ViewModelLocator.MainStatic.User.Sex;
                                    this.BloodGroup = ViewModelLocator.MainStatic.User.BloodGroup;
                                    this.RHEdit = ViewModelLocator.MainStatic.User.BloodRh;
                                    this.UserDataSet = true;
                                };
                            }
                            catch { };

                            this.EditButton.Visibility = Visibility.Collapsed;
                            this.DeleteUserButton.Visibility = Visibility.Collapsed;

                            this.RegisterForm.Visibility = Visibility.Collapsed;
                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Collapsed;
                            this.EditProfile.Visibility = Visibility.Visible;

                            if ((ViewModelLocator.MainStatic.User.FacebookId != "") && (ViewModelLocator.MainStatic.User.FacebookId != null))
                            {
                                this.FacebookLinkingButton.Visibility = Visibility.Collapsed;
                                this.FacebookUnLinkingButton.Visibility = Visibility.Visible;
                            }
                            else
                            {
                                this.FacebookLinkingButton.Visibility = Visibility.Visible;
                                this.FacebookUnLinkingButton.Visibility = Visibility.Collapsed;
                            };

                            AppBarVisibitilty("edit");
                            CurrentTask = "edit";

                            SetEditFields();

                            break;
                        default:
                            AppBarVisibitilty("");
                            CurrentTask = "";
                            break;
                    };
                }
                catch
                {
                };
            }
            else
            {
                //AppBarVisibitilty("show");   
            };

            /*if (ViewModelLocator.MainStatic.User.IsLoggedIn == true)
            {
                this.AppBar.IsVisible = true;
            }
            else
            {
                this.AppBar.IsVisible = false;
            };*/
            this.AppBar.IsVisible = true;
        }

        private void SetEditFields() {
            /*
             *              this.Sex = ViewModelLocator.MainStatic.User.Sex;
                            this.BloodGroup = ViewModelLocator.MainStatic.User.BloodGroup;
                            this.RHEdit = ViewModelLocator.MainStatic.User.BloodRh;*/
            try
            {
                if (this.Sex == 1)
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
                this.BloudTypeGroupEdit.SelectedIndex = this.BloodGroup;
            }
            catch { };

            try
            {
                this.RHedit.SelectedIndex = this.RHEdit;
            }
            catch { };
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            this.EditProfile.Visibility = Visibility.Visible;

            if ((ViewModelLocator.MainStatic.User.FacebookId != "") && (ViewModelLocator.MainStatic.User.FacebookId != null))
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

            this.CancelEditProfileButton.Visibility = Visibility.Visible;
            this.SaveEditProfileButton.Visibility = Visibility.Visible;

            CurrentTask = "edit";

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

            CurrentTask = "show";
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
                ViewModelLocator.MainStatic.User.BloodGroup = this.BloudTypeGroupEdit.SelectedIndex;
            }
            catch { };

            try
            {
                ViewModelLocator.MainStatic.User.Sex = this.SexEditGroup.SelectedIndex;
            }
            catch { };

            try
            {
                ViewModelLocator.MainStatic.User.BloodRh = this.RHedit.SelectedIndex;
            }
            catch { };

            try
            {
                ViewModelLocator.MainStatic.User.Name = this.EditName.Text;
                ViewModelLocator.MainStatic.User.SecondName = this.EditSecondName.Text;
            }
            catch
            {
            };

            ViewModelLocator.MainStatic.User.UpdateAction(null);

            this.EditProfile.Visibility = Visibility.Collapsed;

            AppBarVisibitilty("show");
            CurrentTask = "show";

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
                    ViewModelLocator.MainStatic.Settings.Password = true;
                    break;
                case "PushCheck":
                    ViewModelLocator.MainStatic.Settings.Push = true;
                    break;
                case "SearchCheck":
                    ViewModelLocator.MainStatic.Settings.FastSearch = true;
                    break;
                case "BeforeCheck":
                    ViewModelLocator.MainStatic.Settings.EventBefore = true;
                    break;
                case "AfterCheck":
                    ViewModelLocator.MainStatic.Settings.EventAfter = true;
                    break;
                default:
                break;
            };
            ViewModelLocator.MainStatic.SaveSettingsToStorage();
        }

        private void Check_Unchecked(object sender, RoutedEventArgs e)
        {
            (sender as ToggleSwitch).Content = "Выключено";
            switch ((sender as ToggleSwitch).Name.ToString())
            {
                case "PasswordCheck":
                    ViewModelLocator.MainStatic.Settings.Password = false;
                    break;
                case "PushCheck":
                    ViewModelLocator.MainStatic.Settings.Push = false;
                    break;
                case "SearchCheck":
                    ViewModelLocator.MainStatic.Settings.FastSearch = false;
                    break;
                case "BeforeCheck":
                    ViewModelLocator.MainStatic.Settings.EventBefore = false;
                    break;
                case "AfterCheck":
                    ViewModelLocator.MainStatic.Settings.EventAfter = false;
                    break;
                default:
                    break;
            };
            ViewModelLocator.MainStatic.SaveSettingsToStorage();
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
                NavigationService.Navigate(new Uri("/Pages/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        private void FacebookUnlinkingButton_Click(object sender, EventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.User.FacebookUnlinking();
            }
            catch
            {
            };
        }

        private void DeleteUserButton_Click(object sender, EventArgs e)
        {
            emailsaved = "";
            passwordsaved = "";
            ViewModelLocator.MainStatic.User.LogoutAction(null);
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            string username = this.email.Text;
            string password = this.password.Password;

            this.email.Text = "";
            this.password.Password = "";

            ViewModelLocator.MainStatic.User.UserName = username;
            ViewModelLocator.MainStatic.User.Password = password;

            ViewModelLocator.MainStatic.User.LoginAction(null);
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
                NavigationService.Navigate(new Uri("/Pages/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
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
            if ((ViewModelLocator.MainStatic.User.IsLoggedIn) && (ViewModelLocator.MainStatic.User.FacebookToken != "") && (ViewModelLocator.MainStatic.User.FacebookId != "") && (ViewModelLocator.MainStatic.User.FacebookToken != null) && (ViewModelLocator.MainStatic.User.FacebookId != null))
            {
                ViewModelLocator.MainStatic.User.FacebookLinking(ViewModelLocator.MainStatic.User.FacebookId, ViewModelLocator.MainStatic.User.FacebookToken);
            }
            else
            {
                try
                {
                    NavigationService.Navigate(new Uri("/Pages/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
                }
                catch
                {
                };
            };
        }

        private void FacebookUnLinkingButton_Click(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.User.FacebookUnlinking();
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

        private void LoginUserButton_Click(object sender, EventArgs e)
        {
            Login_Click(sender, null);
        }

        private void AppBarVisibitilty(string taskChange = "")
        {
            this.LoginUserButton.Visibility = Visibility.Collapsed;
            this.CancelEditProfileButton.Visibility = Visibility.Collapsed;
            this.SaveEditProfileButton.Visibility = Visibility.Collapsed;
            this.DeleteUserButton.Visibility = Visibility.Collapsed;
            this.EditButton.Visibility = Visibility.Collapsed;
            this.RegisterUserButton.Visibility = Visibility.Collapsed;

            switch (taskChange) {
                case "login":
                    this.LoginUserButton.Visibility = Visibility.Visible;
                    break;
                case "register":
                    this.RegisterUserButton.Visibility = Visibility.Visible;
                    break;
                case "edit":
                    this.CancelEditProfileButton.Visibility = Visibility.Visible;
                    this.SaveEditProfileButton.Visibility = Visibility.Visible;
                    break;
                case "show":
                    this.EditButton.Visibility = Visibility.Visible;
                    this.DeleteUserButton.Visibility = Visibility.Visible;
                    break;
                case "":
                    this.AppBar.IsVisible = false;
                    break;
                default: 
                    this.AppBar.IsVisible = false;
                    break;
            };
        }

        private void RegisterUserButton_Click(object sender, EventArgs e)
        {
            RegisterButton_Click(sender, null);
        }

        private void SexEditGroup_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                this.Sex = this.SexEditGroup.SelectedIndex;
            }
            catch { };
        }

        private void BloudTypeGroupEdit_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                this.BloodGroup = this.BloudTypeGroupEdit.SelectedIndex;
            }
            catch { };
        }

        private void BloudTypeGroupEdit_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                this.BloodGroup = this.BloudTypeGroupEdit.SelectedIndex;
            }
            catch { };
        }

        private void RHedit_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                this.RHEdit = this.RHedit.SelectedIndex;
            }
            catch { };
        }

        private void SexEditGroup_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                this.Sex = this.SexEditGroup.SelectedIndex;
            }
            catch { };
        }

        private void RHedit_SizeChanged(object sender, SizeChangedEventArgs e)
        {

        }

        private void RHedit_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                this.RHEdit = this.RHedit.SelectedIndex;
            }
            catch { };
        }
    }
}