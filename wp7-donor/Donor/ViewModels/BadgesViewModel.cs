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
using RestSharp;
using Newtonsoft.Json.Linq;
using Coding4Fun.Phone.Controls;
using Donor.Controls;

namespace Donor.ViewModels
{
    static public class BadgesViewModel
    {
        static public string activation_code = "";

        /// <summary>
        /// Получение кода активации достижения:
        /// POST http://www.itsbeta.com/s/категория/проект/achieves/postachieve.json
        /// Параметры:
        /// ● access_token: String = токен доступа
        /// ● badge_name: String = шаблон достижения
        /// </summary>
        static public void PostAchieve(string user_id = "", string user_token="")
        {

                    var client = new RestClient("http://www.itsbeta.com");
                    var request = new RestRequest("s/healthcare/donor/achieves/posttofbonce.json", Method.POST);
                    request.Parameters.Clear();
                    request.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
                    request.AddParameter("user_id", user_id);
                    request.AddParameter("user_token", user_token);
                    request.AddParameter("badge_name", "donorfriend");

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            JObject o = JObject.Parse(response.Content.ToString());
                            if (o["id"].ToString() != "")
                            {
                                string facebook_id = o["fb_id"].ToString();
                                MessagePrompt messagePrompt = new MessagePrompt();
                                try
                                {
                                    messagePrompt.Body = new BadgeControl();
                                }
                                catch
                                {
                                };
                                messagePrompt.Show();
                            };
                        }
                        catch { };
                    });
        }

    }
}
