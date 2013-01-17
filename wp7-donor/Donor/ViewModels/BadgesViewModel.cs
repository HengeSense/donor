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
            var clientActivation = new RestClient("http://www.itsbeta.com");
            var requestActivation = new RestRequest("s/healthcare/donor/achieves/postachieve.json", Method.POST);
            requestActivation.Parameters.Clear();

            requestActivation.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
            requestActivation.AddParameter("badge_name", "donorfriend");

            clientActivation.ExecuteAsync(requestActivation, responseActivation =>
            {
                try
                {
                    JObject oActivation = JObject.Parse(responseActivation.Content.ToString());
                    string activation_code = oActivation["activation_code"].ToString();

                    /*  2. Активация достижения на FB по коду:
                        POST http://www.itsbeta.com/s/категория/проект/achieves/posttofb.json
                        Параметры:
                        ● access_token: String = токен доступа
                        ● user_id: String = ID пользователя на FB
                        ● user_token: String = access_token пользователя на FB
                        ● activation_code: String = код активации достижения
                        Ответ:
                        {
                        "id" : String // ID достижения в базе
                        }
                     */

                    var client = new RestClient("http://www.itsbeta.com");
                    var request = new RestRequest("s/healthcare/donor/achieves/posttofb.json", Method.POST);
                    request.Parameters.Clear();
                    request.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
                    request.AddParameter("user_id", user_id);
                    request.AddParameter("user_token", user_token);
                    request.AddParameter("activation_code", activation_code);

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            JObject o = JObject.Parse(response.Content.ToString());
                        }
                        catch { };
                    });
                }
                catch { };
            });
        }

    }
}
