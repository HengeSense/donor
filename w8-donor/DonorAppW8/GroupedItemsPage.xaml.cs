using DonorAppW8.DataModel;
//using DonorAppW8.Data;
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

// Шаблон элемента страницы сгруппированных элементов задокументирован по адресу http://go.microsoft.com/fwlink/?LinkId=234231

namespace DonorAppW8
{
    /// <summary>
    /// Страница, на которой отображается сгруппированная коллекция элементов.
    /// </summary>
    public sealed partial class GroupedItemsPage : DonorAppW8.Common.LayoutAwarePage
    {
        public GroupedItemsPage()
        {
            this.InitializeComponent();

            ViewModelLocator.MainStatic.LoadData();
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
            // TODO: Создание соответствующей модели данных для области проблемы, чтобы заменить пример данных
            //var sampleDataGroups = SampleDataSource.GetGroups((String)navigationParameter);
            //this.DefaultViewModel["Groups"] = sampleDataGroups;
            zommedOutView.ItemsSource = groupedItemsViewSource.View.CollectionGroups;
        }

        /// <summary>
        /// Вызывается при нажатии заголовка группы.
        /// </summary>
        /// <param name="sender">Объект Button, используемый в качестве заголовка выбранной группы.</param>
        /// <param name="e">Данные о событии, описывающие, каким образом было инициировано нажатие.</param>
        void Header_Click(object sender, RoutedEventArgs e)
        {
            // Определение группы, представляемой экземпляром Button
            var group = (sender as FrameworkElement).DataContext;

            // Переход к соответствующей странице назначения и настройка новой страницы
            // путем передачи необходимой информации в виде параметра навигации
            if ((group as RssDataGroup).UniqueId == "Ads")
            {
                this.Frame.Navigate(typeof(AdGroupDetailPage), (group as RssDataGroup).UniqueId);
            };
            if ((group as RssDataGroup).UniqueId == "News")
            {
                this.Frame.Navigate(typeof(NewsGroupDetailPage), (group as RssDataGroup).UniqueId);
            };
            if ((group as RssDataGroup).UniqueId == "CurrentStations")
            {
                this.Frame.Navigate(typeof(StationsGroupDetailPage), (group as RssDataGroup).UniqueId);
            };
        }

        /// <summary>
        /// Вызывается при нажатии элемента внутри группы.
        /// </summary>
        /// <param name="sender">Объект GridView (или ListView, если приложение прикреплено),
        /// в котором отображается нажатый элемент.</param>
        /// <param name="e">Данные о событии, описывающие нажатый элемент.</param>
        void ItemView_ItemClick(object sender, ItemClickEventArgs e)
        {
            // Переход к соответствующей странице назначения и настройка новой страницы
            // путем передачи необходимой информации в виде параметра навигации
            //var itemId = "test"; // ((SampleDataItem)e.ClickedItem).UniqueId;
            if (e.ClickedItem.GetType() == typeof(AdsViewModel))
            {
                this.Frame.Navigate(typeof(AdDetailPage), ((AdsViewModel)e.ClickedItem).UniqueId);
            };
            if (e.ClickedItem.GetType() == typeof(NewsViewModel))
            {
                this.Frame.Navigate(typeof(NewsViewModel), ((NewsViewModel)e.ClickedItem).UniqueId);
            };
            if (e.ClickedItem.GetType() == typeof(YAStationItem))
            {
                this.Frame.Navigate(typeof(StationDetailPage), ((YAStationItem)e.ClickedItem).UniqueId);
            };
        }
    }
}
