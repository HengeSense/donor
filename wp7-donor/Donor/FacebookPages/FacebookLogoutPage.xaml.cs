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
    public partial class FacebookLogoutPage : PhoneApplicationPage
    {
        private const string AppId = "438918122827407";

        /// <summary>
        /// Extended permissions is a comma separated list of permissions to ask the user.
        /// </summary>
        /// <remarks>
        /// For extensive list of available extended permissions refer to 
        /// https://developers.facebook.com/docs/reference/api/permissions/
        /// </remarks>
        private const string ExtendedPermissions = "user_about_me,read_stream,publish_stream";

        private readonly FacebookClient _fb = new FacebookClient();

        public FacebookLogoutPage()
        {
            InitializeComponent();
        }

        private void webBrowser1_Loaded(object sender, RoutedEventArgs e)
        {
            //var logoutUrl = GetFacebookLogoutUrl(AppId, ExtendedPermissions);
            //webBrowser1.Navigate(logoutUrl);

            string logout_format = "http://www.facebook.com/logout.php?api_key={0}&session_key={1}&next={2}";
            string access_token = HttpUtility.UrlDecode(ViewModelLocator.MainStatic.User.FacebookToken);
            //char[] tokenSeparator = new char[] { '|' };
            //string session = access_token.Split(tokenSeparator)[1];
            string session = ViewModelLocator.MainStatic.User.FacebookToken;

            var parameters = new Dictionary<string, object>();
            webBrowser1.Navigate(_fb.GetLogoutUrl(parameters));
        }

        private Uri GetFacebookLogoutUrl(string appId, string extendedPermissions)
        {
            var parameters = new Dictionary<string, object>();
            //parameters["client_id"] = appId;
            //parameters["redirect_uri"] = "https://www.facebook.com/logout.php";
            parameters["next"] = "https://www.facebook.com/logout.php";
            //parameters["display"] = "touch";
            parameters["access_token"] = ViewModelLocator.MainStatic.User.FacebookToken;

            return _fb.GetLogoutUrl(parameters);
        }

        private void webBrowser1_Navigated(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            this.NavigationService.GoBack();
            /*FacebookOAuthResult oauthResult;
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
            }*/
        }
    }
}