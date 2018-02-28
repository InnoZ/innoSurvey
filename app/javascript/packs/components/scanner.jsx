import React from 'react';

import jsQR from "jsqr";

export default class ExhibitionScreen extends React.Component {
  constructor(props) {
    super(props);
    this.tick = this.tick.bind(this)
  }

  resetCamera() {
    if (navigator.mediaDevices) {
      video.pause();
      video.src = '';
      video.load();
      cancelAnimationFrame(animationFrame);
    }
  }

  componentWillUnmount() {
    this.resetCamera();
  }

  componentWillUpdate() {
    this.resetCamera();
    this.initCamera();
  }

  componentDidMount() {
    this.initCamera();
  }

  initCamera() {
    if (navigator.mediaDevices) {
      const that = this;
      window.video = document.createElement("video");
      window.canvasElement = document.getElementById("canvas");
      window.canvas = canvasElement.getContext("2d");
      navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: "environment"
        }
      }).then(function(stream) {
        video.srcObject = stream;
        video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
        video.play();
        window.animationFrame = requestAnimationFrame(that.tick);
      });
    }
  }

  tick() {
    const that = this;
    if (video.readyState === video.HAVE_ENOUGH_DATA) {
      canvasElement.height = video.videoHeight;
      canvasElement.width = video.videoWidth;
      canvas.translate(canvasElement.width, 0);
      canvas.scale(-1, 1);
      canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);
      var imageData = canvas.getImageData(0, 0, canvasElement.width, canvasElement.height);
      var code = jsQR(imageData.data, imageData.width, imageData.height);
      if (code) {
        that.props.ident(code.data);
      };
    }
    window.animationFrame = requestAnimationFrame(that.tick);
  }

  fakeQrScan(event) {
    const uuid = document.getElementById('uuid-test-input').value;
    const roleId = document.getElementById('role-id-test-input').value;
    const fakedScanData = `{"uuid": "${uuid}", "role_id": "${roleId}"}`;
    this.props.ident(fakedScanData);
  }

  render() {
    return (
      <div>
        <div className='header'>Scanne deinen QR-Code</div>
        <div className='subtitle'>Du hast keinen? Besorge dir einen am Eingang</div>
        <canvas id="canvas"></canvas>

        <div className='qr-code-test-replacement-input'>
          <input id='uuid-test-input'></input>
          <input id='role-id-test-input'></input>
          <button id='send-fake-qr' onClick={this.fakeQrScan.bind(this)}>submit</button>
        </div>
      </div>
    );
  }
}
