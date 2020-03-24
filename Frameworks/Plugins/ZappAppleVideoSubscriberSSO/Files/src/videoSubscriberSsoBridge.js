import { NativeModules } from "react-native";
// eslint-disable-next-line prefer-promise-reject-errors
const nullPromise = () => Promise.reject("SSO module is Null");
const videoSubscriberSSO = {
  requestSso: nullPromise,
};
const { VideoSubscriberSSO = videoSubscriberSSO } = NativeModules;
export const videoSubscriberSSO = {
  /**
 * Request SSO procedure
 * @return {Promise<Boolean>} response promise
 */
  async requestSso() {
    try {
      return VideoSubscriberSSO.requestSso();
    } catch (e) {
      throw e;
    }
  }
}
