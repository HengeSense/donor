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
using Facebook;
using Donor;
using Donor.ViewModels;

namespace facebook_windows_phone_sample.Pages
{
    public partial class FacebookLoginPage : PhoneApplicationPage
    {
        private const string AppId = "264918200296425";

        /// <summary>
        /// Extended permissions is a comma separated list of permissions to ask the user.
        /// </summary>
        /// <remarks>
        /// For extensive list of available extended permissions refer to 
        /// https://developers.facebook.com/docs/reference/api/permissions/
        /// </remarks>
        private const string ExtendedPermissions = "user_about_me, read_stream, publish_stream, publish_actions, email, user_birthday";

        private readonly FacebookClient _fb = new FacebookClient();

        public FacebookLoginPage()
        {
            InitializeComponent();
        }

        private void webBrowser1_Loaded(object sender, RoutedEventArgs e)
        {
            var loginUrl = GetFacebookLoginUrl(AppId, ExtendedPermissions);
            webBrowser1.Navigate(loginUrl);
        }

        private Uri GetFacebookLoginUrl(string appId, string extendedPermissions)
        {
            var parameters = new Dictionary<string, object>();
            parameters["client_id"] = appId;
            parameters["redirect_uri"] = "https://www.facebook.com/connect/login_success.html";
            parameters["response_type"] = "token";
            parameters["display"] = "touch";

            // add the 'scope' only if we have extendedPermissions.
            if (!string.IsNullOrEmpty(extendedPermissions))
            {
                // A comma-delimited list of permissions
                parameters["scope"] = extendedPermissions;
            }

            return _fb.GetLoginUrl(parameters);
        }

        private void webBrowser1_Navigated(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            FacebookOAuthResult oauthResult;
            if (!_fb.TryParseOAuthCallbackUrl(e.Uri, out oauthResult))
            {
                return;
            }

            if (oauthResult.IsSuccess)
            {

                var accessToken = oauthResult.AccessToken;
                LoginSucceded(accessToken);
            }
            else
            {
                // user cancelled
                MessageBox.Show(oauthResult.ErrorDescription);
            }
        }

        private void LoginSucceded(string accessToken)
        {
            var fb = new FacebookClient(accessToken);

            fb.GetCompleted += (o, e) =>
            {
                if (e.Error != null)
                {
                    Dispatcher.BeginInvoke(() => MessageBox.Show(e.Error.Message));
                    return;
                }

                var result = (IDictionary<string, object>)e.GetResultData();
                var id = (string)result["id"];

                var url = string.Format("/Pages/FacebookPages/FacebookInfoPage.xaml?access_token={0}&id={1}", accessToken, id);
                

                Dispatcher.BeginInvoke(() => {
                    ViewModelLocator.MainStatic.User.FacebookId = id;
                    ViewModelLocator.MainStatic.User.FacebookToken = accessToken;

                    if (ViewModelLocator.MainStatic.User.IsLoggedIn)
                    {
                        ViewModelLocator.MainStatic.User.FacebookLinking(id, accessToken);

                    } else {
                        ViewModelLocator.MainStatic.User.FacebookLogin(id, accessToken, result);
                        ViewModelLocator.MainStatic.FbId = id;
                        ViewModelLocator.MainStatic.FbToken = accessToken;
                    };

                    NavigationService.GoBack(); //NavigationService.Navigate(new Uri(url, UriKind.Relative)));
                    
                });
            };

            fb.GetAsync("me");

        }

        private void webBrowser1_Navigating(object sender, NavigatingEventArgs e)
        {
            //var test = e;
            FacebookOAuthResult oauthResult;
            if (!_fb.TryParseOAuthCallbackUrl(e.Uri, out oauthResult))
            {
                return;
            }

            if (oauthResult.IsSuccess)
            {

                var accessToken = oauthResult.AccessToken;
                LoginSucceded(accessToken);
            }
            else
            {
                // user cancelled
                MessageBox.Show(oauthResult.ErrorDescription);
            }
        }

        private void webBrowser1_NavigationFailed(object sender, System.Windows.Navigation.NavigationFailedEventArgs e)
        {

        }
    }
}