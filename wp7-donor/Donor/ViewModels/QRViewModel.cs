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
using com.google.zxing;
using RestSharp;
using Newtonsoft.Json.Linq;
using Facebook;
using System.Windows.Threading;
using System.Collections.Generic;

namespace Donor.ViewModels
{
    public class QRViewModel
    {
        /// <summary>
        /// Init QR viewmodel. QR to empty string by default
        /// </summary>
        public QRViewModel()
        {
            _qrcode = "";
        }

        /// <summary>
        /// Facebook token for auth session
        /// </summary>
        public string FacebookToken { get; set; }

        /// <summary>
        /// User id at facebook
        /// </summary>
        public string FacebookId {get; set; }

        private string _qrcode;
        private string _lastMessageId;
        public string QRcode
        {
            get { return _qrcode; }
            set { 
                _qrcode = value;
                SaveQrLevel();
            }
        }


        /// <summary>
        /// Add score points for user at facebook
        /// </summary>
        /// <param name="score"></param>
        private void AddScore(int score)
        {
            var client = new RestClient("https://graph.facebook.com/");
            var request = new RestRequest(App.ViewModel.User.FacebookId.ToString()+"/scores?score="+score.ToString()+"&access_token="+App.ViewModel.User.FacebookToken, Method.GET);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();

            client.ExecuteAsync(request, response =>
            {
                JObject o = JObject.Parse(response.Content.ToString());
            });
        }

        public void SaveQrLevel()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Facebook", Method.POST);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();

            string strJSONContent = "{\"facebook_user_id\":\"" + "1" + "\", \"level\":" + "1" + ", \"user_id\":\"" + App.ViewModel.User.objectId + "\", \"qr\":\"" + HttpUtility.UrlEncode(this.QRcode).ToString() + "\"}";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddHeader("Content-Type", "application/json");

            request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

            client.ExecuteAsync(request, response =>
            {
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {

                    AddScore(1);

                    var fb = new FacebookClient(App.ViewModel.User.FacebookToken);

                    ///
                    /// Post message to timeline
                    ///
                    /*fb.PostCompleted += (o1, args) =>
                    {
                        if (args.Error != null)
                        {
                            return;
                        }
                        var result = (IDictionary<string, object>)args.GetResultData();
                        _lastMessageId = (string)result["id"];
                    };
                    var parameters = new Dictionary<string, object>();
                    parameters["message"] = QRcode;
                    fb.PostAsync("me/feed", parameters);*/

                    /*fb.PostCompleted += (o1, args) =>
                    {
                        if (args.Error != null)
                        {
                            return;
                        }
                        var result = (IDictionary<string, object>)args.GetResultData();                        
                    };
                    var parameters = new Dictionary<string, object>();
                    parameters["achievement"] = "acheeve_path";
                    fb.PostAsync("/me/achievements", parameters);*/

                    MessageBox.Show("QR добавлен.");
                }
                else
                {
                    MessageBox.Show("Не удалось добавить QR код.");
                };

            });
        }
    }

    public class PhotoCameraLuminanceSource : LuminanceSource
    {
        public byte[] PreviewBufferY { get; private set; }

        public PhotoCameraLuminanceSource(int width, int height)
            : base(width, height)
        {
            PreviewBufferY = new byte[width * height];
        }

        public override sbyte[] Matrix
        {
            get { return (sbyte[])(Array)PreviewBufferY; }
        }

        public override sbyte[] getRow(int y, sbyte[] row)
        {
            if (row == null || row.Length < Width)
            {
                row = new sbyte[Width];
            }

            for (int i = 0; i < Height; i++)
                row[i] = (sbyte)PreviewBufferY[i * Width + y];

            return row;
        }
    }

}
