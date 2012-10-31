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
using com.google.zxing.qrcode;
using Microsoft.Devices;
using System.Collections.ObjectModel;
using System.Windows.Threading;
using System.Windows.Navigation;
using com.google.zxing;
using com.google.zxing.common;
using Donor.ViewModels;

namespace Donor
{


    public partial class QRread : PhoneApplicationPage
    {
        private readonly DispatcherTimer _timer;
        private readonly ObservableCollection<string> _matches;

        private PhotoCameraLuminanceSource _luminance;
        private QRCodeReader _reader;
        private PhotoCamera _photoCamera;

        public QRread()
        {
            InitializeComponent();

            _matches = new ObservableCollection<string>();
            _matchesList.ItemsSource = _matches;

            _timer = new DispatcherTimer();
            _timer.Interval = TimeSpan.FromMilliseconds(250);
            _timer.Tick += (o, arg) => ScanPreviewBuffer();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            try
            {
                //if (App.ViewModel.Qr.CameraFocusSet == false)
                //{
                    _photoCamera = new PhotoCamera();
                    _photoCamera.Initialized += OnPhotoCameraInitialized;
                    _previewVideo.SetSource(_photoCamera);
                //}
            }
            catch { };

            try
            {
                if (App.ViewModel.Qr.CameraFocusSet == false)
                {
                    CameraButtons.ShutterKeyHalfPressed += (o, arg) => { try { _photoCamera.Focus(); } catch { }; };
                    App.ViewModel.Qr.CameraFocusSet = true;
                };
            }
            catch
            {
            };

            base.OnNavigatedTo(e);
        }

        private void OnPhotoCameraInitialized(object sender, CameraOperationCompletedEventArgs e)
        {
            try
            {
                int width = Convert.ToInt32(_photoCamera.PreviewResolution.Width);
                int height = Convert.ToInt32(_photoCamera.PreviewResolution.Height);

                _luminance = new PhotoCameraLuminanceSource(width, height);
                _reader = new QRCodeReader();

                Dispatcher.BeginInvoke(() =>
                {
                    _previewTransform.Rotation = _photoCamera.Orientation;
                    _timer.Start();
                });
            }
            catch
            {
            };
        }

        private void ScanPreviewBuffer()
        {
            try
            {
                _photoCamera.GetPreviewBufferY(_luminance.PreviewBufferY);
                var binarizer = new HybridBinarizer(_luminance);
                var binBitmap = new BinaryBitmap(binarizer);
                var result = _reader.decode(binBitmap);
                Dispatcher.BeginInvoke(() => DisplayResult(result.Text));
            }
            catch
            {
            }
        }

        private void DisplayResult(string text)
        {
            _timer.Stop();
            //_photoCamera.Dispose();
            try
            {
                MessageBox.Show("Добавлен QR код c текстом: \n" + text);
                App.ViewModel.Qr.QRcode = text;
                try
                {
                    this.NavigationService.GoBack();
                }
                catch { };
            }
            catch { };
        }


    }
}