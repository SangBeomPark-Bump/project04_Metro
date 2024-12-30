/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// 사용자 목록을 가져오는 함수
exports.listUsers = functions.https.onCall(async (data, context) => {
    const users = [];
    let nextPageToken;

    // 최대 100명의 사용자만 가져오기
    try {
        do {
            const listUsersResult = await admin.auth().listUsers(100, nextPageToken);
            users.push(...listUsersResult.users); // 가져온 사용자 목록을 배열에 추가
            nextPageToken = listUsersResult.pageToken; // 다음 페이지 토큰
        } while (nextPageToken); // 모든 페이지를 가져올 때까지 반복

        return {
            success: true, users: users.map((user) => ({
                uid: user.uid,
                email: user.email,
                displayName: user.displayName,
                photoURL: user.photoURL,
            })),
        };
    } catch (error) {
        return {success: false, message: error.message};
    }
});

// 사용자 삭제 함수
exports.deleteUser = functions.https.onCall(async (data, context) => {
    const uid = data.uid;

    try {
        await admin.auth().deleteUser(uid);
        return {success: true, message: "User deleted successfully."};
    } catch (error) {
        return {success: false, message: error.message};
    }
});

// 이메일 수정 함수
exports.updateEmail = functions.https.onCall(async (data, context) => {
    const uid = data.uid;
    const newEmail = data.newEmail;

    // 디버깅: 받은 uid와 newEmail 확인
    console.log(`Received UID: ${uid}, New Email: ${newEmail}`); 

    // UID와 이메일 검증
    if (!uid || !newEmail) {
        console.log('UID or email is missing'); // 디버깅
        return {success: false, message: "UID and new email are required."};
    }

    try {
        await admin.auth().updateUser(uid, {
            email: newEmail,
        });
        console.log(`Email updated successfully for UID: ${uid}`); // 디버깅
        return {success: true, message: "Email updated successfully."};
    } catch (error) {
        console.error(`Error updating email: ${error.message}`); // 디버깅
        return {success: false, message: error.message};
    }
});



// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
