//using DonorAppW8.Data;

using Bing.Maps;
using DonorAppW8.ViewModel;
using DonorAppW8.ViewModels;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// Шаблон элемента страницы сведений об элементе задокументирован по адресу http://go.microsoft.com/fwlink/?LinkId=234232

namespace DonorAppW8
{
    /// <summary>
    /// Страница, на которой отображаются сведения об отдельном элементе внутри группы; при этом можно с помощью жестов
    /// перемещаться между другими элементами из этой группы.
    /// </summary>
    public sealed partial class StationDetailPage : DonorAppW8.Common.LayoutAwarePage
    {
        public StationDetailPage()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Заполняет страницу содержимым, передаваемым в процессе навигации. Также предоставляется любое сохраненное состояние
        /// при повторном создании страницы из предыдущего сеанса.
        /// </summary>
        /// <param name="navigationParameter">Значение параметра, передаваемое
        /// <see cref="Frame.Navigate(Type, Object)"/> при первоначальном запросе этой страницы.
        /// </param>
        /// <param name="pageState">Словарь состояния, сохраненного данной страницей в ходе предыдущего
        /// сеанса. Это значение будет равно NULL при первом посещении страницы.</param>
        protected override void LoadState(Object navigationParameter, Dictionary<String, Object> pageState)
        {
            // Разрешение сохраненному состоянию страницы переопределять первоначально отображаемый элемент
            if (pageState != null && pageState.ContainsKey("SelectedItem"))
            {
                navigationParameter = pageState["SelectedItem"];
            }

            // TODO: Создание соответствующей модели данных для области проблемы, чтобы заменить пример данных
            var item = ViewModelLocator.MainStatic.Stations.Items.FirstOrDefault(c => c.UniqueId == (String)navigationParameter);
            this.DefaultViewModel["Group"] = ViewModelLocator.MainStatic.Groups.FirstOrDefault(c=>c.UniqueId=="CurrentStations");
            this.DefaultViewModel["Items"] = ViewModelLocator.MainStatic.Groups.FirstOrDefault(c => c.UniqueId == "CurrentStations").Items;
            this.flipView.SelectedItem = item;

            Pushpin pushpin = new Pushpin();
                MapLayer.SetPosition(pushpin, new Location(item.Lat, item.Lon));
                pushpin.Name = item.UniqueId;
                //pushpin.Tapped += pushpinTapped;
                //map.Children.Add(pushpin);
            //map.SetView(new Location(ViewModelLocator.MainStatic.Stations.Latitued, ViewModelLocator.MainStatic.Stations.Longitude), 11);
        }

        /// <summary>
        /// Сохраняет состояние, связанное с данной страницей, в случае приостановки приложения или
        /// удаления страницы из кэша навигации. Значения должны соответствовать требованиям сериализации
        /// <see cref="SuspensionManager.SessionState"/>.
        /// </summary>
        /// <param name="pageState">Пустой словарь, заполняемый сериализуемым состоянием.</param>
        protected override void SaveState(Dictionary<String, Object> pageState)
        {
            try
            {
                var selectedItem = (YAStationItem)this.flipView.SelectedItem;
                pageState["SelectedItem"] = selectedItem.UniqueId;
            }
            catch { };
        }
    }
}
