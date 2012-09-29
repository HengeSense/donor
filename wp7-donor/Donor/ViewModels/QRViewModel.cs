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

namespace Donor.ViewModels
{
    public class QRViewModel
    {
        public QRViewModel()
        {
            _qrcode = "";
        }

        private string _qrcode;
        public string QRcode
        {
            get { return _qrcode; }
            set { 
                _qrcode = value;
                SaveQrLevel();
            }
        }

        public void SaveQrLevel()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Facebook", Method.POST);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();

            string strJSONContent = "{\"facebook_user_id\":\"" + "1" + "\", \"level\":" + "1"  + ", \"user_id\":\"" + App.ViewModel.User.objectId + "\", \"qr\":\""+this.QRcode+"\"}";
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
                //NavigationService.GoBack();
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
