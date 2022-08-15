/*
		Argentum Forever - Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
		gulfas@gmail.com
*/
using System;
﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEditor;
using UnityEngine.Localization.Settings;
using UnityEngine.Localization;
using UnityEngine.EventSystems;
using System.Linq;
using Mirror;

public class MainMenu : MonoBehaviour
{
    private EventSystem mEventSystem;
    public LocalizedString LoginErrText_MSGBOX_TITLE;
    public LocalizedString SignupErrText_MSGBOX_TITLE;
    public LocalizedString LoginErrText_USER_ALREADY_HOLDS_ACTIVE_SESSION;
    public LocalizedString LoginErrText_ACCOUNT_DOESNT_EXIST;
    public LocalizedString LoginErrText_MUST_ACTIVATE_ACCOUNT;
    public LocalizedString LoginErrText_INVALID_PUBLIC_KEY;

    public LocalizedString WorldErrText_PLAY_CHARACTER_OKAY_TITLE;
    public LocalizedString WorldErrText_PLAY_CHARACTER_OKAY_TEXT;
    public LocalizedString WorldErrText_PLAY_CHARACTER_ERROR_TITLE;
    public LocalizedString WorldErrText_PLAY_CHARACTER_ERROR_TEXT;
    public LocalizedString WorldErrText_CONNECTION_CLOSED_BY_SERVER_TEXT;

    public LocalizedString LoginErrText_LOGIN_ERROR_WRONG_PASSWORD;
    public LocalizedString SignupErrText_ACCOUNT_ALREADY_EXIST;
    public LocalizedString InputErrText_INPUT_ERROR_INVALID_PASSWORD;
    public LocalizedString InputErrText_INPUT_ERROR_INVALID_CONFIRM_PASSWORD;
    public LocalizedString InputErrText_INPUT_ERROR_INVALID_USERNAME;
    public LocalizedString InputErrText_INPUT_ERROR_INVALID_ACTIVATION_CODE;
    public LocalizedString InputErrText_INPUT_ERROR_TITLE;
    public LocalizedString ConnectionErrText_CONNECTION_ERROR_MSGBOX_TITLE;
    public LocalizedString ConnectionErrText_CONNECTION_ERROR_CANNOT_REACH_SERVER;

    public LocalizedString SignupErrText_PASSWORD_TOO_SHORT;
    public LocalizedString SignupErrText_PASSWORD_TOO_LONG;
    public LocalizedString SignupErrText_PASSWORD_IS_NOT_ALNUM;
    public LocalizedString SignupErrText_USERNAME_TOO_SHORT;
    public LocalizedString SignupErrText_USERNAME_TOO_LONG;
    public LocalizedString SignupErrText_USERNAME_IS_NOT_ALNUM;
    public LocalizedString SignupErrText_PASSWORD_CANNOT_CONTAIN_USERNAME;
    public LocalizedString SignupErrText_USERNAME_CANNOT_START_WITH_NUMBER;
    public LocalizedString SignupErrText_PASSWORD_MUST_HAVE_ONE_UPPERCASE;
    public LocalizedString SignupErrText_PASSWORD_MUST_HAVE_ONE_LOWERCASE;
    public LocalizedString SignupErrText_PASSWORD_MUST_HAVE_TWO_NUMBERS;
    public LocalizedString SignupErrText_INVALID_EMAIL;
    public LocalizedString SignupErrText_INVALID_CONFIRM_EMAIL;
    public LocalizedString SignupErrText_INVALID_FIRST_LAST_NAME;
    public LocalizedString SignupErrText_TERMS_NOT_ACCEPTED;
    public LocalizedString Signup_RESEND_CODE_OK;

    public LocalizedString ActivateOkayText_ACTIVATE_OKAY;
    public LocalizedString ActivateErrText_ACTIVATE_ERROR_INVALID_CODE;
    public LocalizedString ActivateErrText_ACTIVATE_MSG_BOX_TITLE;

    public LocalizedString SignupText_TERMS_CONDITIONS_TITLE;
    public LocalizedString SignupText_TERMS_CONDITIONS_TEXT;
    public bool IsLoginPanel;

    protected string services_server_address = "86.21.218.127";
    protected string services_server_port = "4000";
    protected string chat_server_port = "7007"; 

    string[] strRaza = new string[] { "GNOMO", "DWARF", "ELF", "HUMANO" }; 


    private void CreateAndInitLocalizedStrings(){
        mLocalizedStringMappings = new Dictionary<string,LocalizedString>();
        mLocalizedStringMappings["LOGIN_ERROR_MSG_BOX_TITLE"]= LoginErrText_MSGBOX_TITLE;
        mLocalizedStringMappings["SIGNUP_ERROR_MSG_BOX_TITLE"]= SignupErrText_MSGBOX_TITLE;
        mLocalizedStringMappings["USER_ALREADY_HOLDS_ACTIVE_SESSION"]= LoginErrText_USER_ALREADY_HOLDS_ACTIVE_SESSION;
        mLocalizedStringMappings["ACCOUNT_DOESNT_EXIST"]= LoginErrText_ACCOUNT_DOESNT_EXIST;
        mLocalizedStringMappings["ACCOUNT_ALREADY_EXISTS"]= SignupErrText_ACCOUNT_ALREADY_EXIST;
        mLocalizedStringMappings["INPUT_ERROR_INVALID_PASSWORD"]= InputErrText_INPUT_ERROR_INVALID_PASSWORD;
        mLocalizedStringMappings["INPUT_ERROR_INVALID_CONFIRM_PASSWORD"] = InputErrText_INPUT_ERROR_INVALID_CONFIRM_PASSWORD;
        mLocalizedStringMappings["INPUT_ERROR_INVALID_USER"]= InputErrText_INPUT_ERROR_INVALID_USERNAME;
        mLocalizedStringMappings["INPUT_ERROR_TITLE"]= InputErrText_INPUT_ERROR_TITLE;
        mLocalizedStringMappings["CONNECTION_ERROR_MSGBOX_TITLE"]= ConnectionErrText_CONNECTION_ERROR_MSGBOX_TITLE;
        mLocalizedStringMappings["CONNECTION_ERROR_CANNOT_REACH_SERVER"]= ConnectionErrText_CONNECTION_ERROR_CANNOT_REACH_SERVER;
        mLocalizedStringMappings["PASSWORD_TOO_SHORT"]= SignupErrText_PASSWORD_TOO_SHORT;
        mLocalizedStringMappings["PASSWORD_TOO_LONG"]= SignupErrText_PASSWORD_TOO_LONG;
        mLocalizedStringMappings["PASSWORD_IS_NOT_ALNUM"]= SignupErrText_PASSWORD_IS_NOT_ALNUM;
        mLocalizedStringMappings["USERNAME_TOO_SHORT"]= SignupErrText_USERNAME_TOO_SHORT;
        mLocalizedStringMappings["USERNAME_TOO_LONG"]= SignupErrText_USERNAME_TOO_LONG;
        mLocalizedStringMappings["USERNAME_IS_NOT_ALNUM"]= SignupErrText_USERNAME_IS_NOT_ALNUM;
        mLocalizedStringMappings["PASSWORD_CANNOT_CONTAIN_USERNAME"]= SignupErrText_PASSWORD_CANNOT_CONTAIN_USERNAME;
        mLocalizedStringMappings["USERNAME_CANNOT_START_WITH_NUMBER"]= SignupErrText_USERNAME_CANNOT_START_WITH_NUMBER;
        mLocalizedStringMappings["PASSWORD_MUST_HAVE_ONE_UPPERCASE"]= SignupErrText_PASSWORD_MUST_HAVE_ONE_UPPERCASE;
        mLocalizedStringMappings["PASSWORD_MUST_HAVE_ONE_LOWERCASE"]= SignupErrText_PASSWORD_MUST_HAVE_ONE_LOWERCASE;
        mLocalizedStringMappings["PASSWORD_MUST_HAVE_TWO_NUMBERS"]= SignupErrText_PASSWORD_MUST_HAVE_TWO_NUMBERS;
        mLocalizedStringMappings["INVALID_EMAIL"]= SignupErrText_INVALID_EMAIL;
        mLocalizedStringMappings["INVALID_PUBLIC_KEY"]= LoginErrText_INVALID_PUBLIC_KEY;
        mLocalizedStringMappings["INVALID_CONFIRM_EMAIL"] = SignupErrText_INVALID_CONFIRM_EMAIL;
        mLocalizedStringMappings["INVALID_FIRST_LAST_NAME"] = SignupErrText_INVALID_FIRST_LAST_NAME;
        mLocalizedStringMappings["TERMS_NOT_ACCEPTED"] = SignupErrText_TERMS_NOT_ACCEPTED;
        mLocalizedStringMappings["RESEND_CODE_OK"] = Signup_RESEND_CODE_OK;
        mLocalizedStringMappings["MUST_ACTIVATE_ACCOUNT"]= LoginErrText_MUST_ACTIVATE_ACCOUNT;
        mLocalizedStringMappings["INPUT_ERROR_INVALID_ACTIVATION_CODE"]= InputErrText_INPUT_ERROR_INVALID_ACTIVATION_CODE;
        mLocalizedStringMappings["ACTIVATE_OKAY"]= ActivateOkayText_ACTIVATE_OKAY;
        mLocalizedStringMappings["ACTIVATE_ERROR_INVALID_CODE"]= ActivateErrText_ACTIVATE_ERROR_INVALID_CODE;
        mLocalizedStringMappings["ACTIVATE_MSG_BOX_TITLE"]= ActivateErrText_ACTIVATE_MSG_BOX_TITLE;
        mLocalizedStringMappings["WRONG_PASSWORD"]= LoginErrText_LOGIN_ERROR_WRONG_PASSWORD;

        mLocalizedStringMappings["PLAY_CHARACTER_OKAY_TITLE"]= WorldErrText_PLAY_CHARACTER_OKAY_TITLE;
        mLocalizedStringMappings["PLAY_CHARACTER_OKAY_TEXT"]= WorldErrText_PLAY_CHARACTER_OKAY_TEXT;
        mLocalizedStringMappings["PLAY_CHARACTER_ERROR_TITLE"]= WorldErrText_PLAY_CHARACTER_ERROR_TITLE;
        mLocalizedStringMappings["PLAY_CHARACTER_ERROR_TEXT"]= WorldErrText_PLAY_CHARACTER_ERROR_TEXT;
        mLocalizedStringMappings["CONNECTION_CLOSED_BY_SERVER_TEXT"]= WorldErrText_CONNECTION_CLOSED_BY_SERVER_TEXT;

        //Ver si se hace por pdf, web o server text
        mLocalizedStringMappings["TERMS_CONDITIONS_TITLE"] = SignupText_TERMS_CONDITIONS_TITLE;
        mLocalizedStringMappings["TERMS_CONDITIONS_TEXT"] = SignupText_TERMS_CONDITIONS_TEXT;
    }
    public void OnRegisterButtonClicked(){
        Debug.Log("OnRegisterButtonClicked");
        mSignupDialog.transform.localScale = new Vector3(1, 1, 1);
        IsLoginPanel = false;
        InputField emailSignUpInput = GameObject.Find("SignUpEmailInputField").GetComponent<InputField>();
        emailSignUpInput.Select();
        emailSignUpInput.ActivateInputField();
    }
    public void OnApplicationQuit(){
        Debug.Log("Application ending after " + Time.time + " seconds");
    }
    public void OnAccountCreated(){
        Debug.Log("AccountCreated");
        mActivateDialog.transform.localScale = new Vector3(1, 1, 1);
    }
    public void OnLoginOkay(){
        Debug.Log("LOGIN_OKAY");
        //At this point the LoginClient logged into the user's account and we hold a valid session Token
        InputField game_server_address_input = GameObject.Find("GameServerIPInputField").GetComponent<InputField>();
        InputField game_server_port_input = GameObject.Find("GameServerPortInputField").GetComponent<InputField>();
        string game_server_address_string = game_server_address_input.text;
        string game_server_port_string = game_server_address_input.text;
        try {
            NetworkManager.singleton.networkAddress = game_server_address_string;
            NetworkManager.singleton.StartClient();
        }
        catch (Exception e){
  			     Debug.Log("Failed to connect to world server " + e);
        }
        try {
              //Attempt to connect to game Server
              Debug.Log("Chat Server address: " + services_server_address + ":" + chat_server_port);
              mChatClient.ConnectToTcpServer(services_server_address, chat_server_port);
        }
        catch (Exception e){
  			     Debug.Log("Failed to connect to chat server " + e);
        }
    }
    public void OnAccountActivated(){
        Debug.Log("AccountActivated");
        mActivateDialog.transform.localScale = new Vector3(0, 0, 0);
        mSignupDialog.transform.localScale = new Vector3(0, 0, 0);
        this.ShowMessageBox("ACTIVATE_MSG_BOX_TITLE","ACTIVATE_OKAY",true);
    }
    public void OnActivationCanceled(){
        Debug.Log("AccountCreated");
        mActivateDialog.transform.localScale = new Vector3(0, 0, 0);
        mSignupDialog.transform.localScale = new Vector3(0, 0, 0);
    }
    public void OnSignupCanceled(){
        Debug.Log("OnSignupCanceled");
        mSignupDialog.transform.localScale = new Vector3(0, 0, 0);
    }
    public void OnSendCodeButton(){
        Debug.Log("OnSendCodeButton");
        //InputField username_input       = GameObject.Find("UsernameInputField").GetComponent<InputField>();
        //InputField password_input       = GameObject.Find("PasswordInputField").GetComponent<InputField>();
        InputField code_input           = GameObject.Find("ActivateCodeInputField").GetComponent<InputField>();

        //Debug.Assert(username_input!=null);
        //Debug.Assert(password_input!=null);
        Debug.Assert(code_input!=null);
        //string username_str             = username_input.text;
        //string password_str             = password_input.text;
        string server_address_string    = "86.21.218.127";
        string server_port_string       = "4000";
        string code_string              = code_input.text;

        if(code_string == null || code_string.Length<8){
            this.ShowMessageBox("INPUT_ERROR_TITLE","INPUT_ERROR_INVALID_ACTIVATION_CODE",true);
            return;
        }
        try {
          //Attempt to connect to game Server
          if( mLoginClient.IsConnected()){
              mLoginClient.AttemptToActivate();
          }
          else {
              Debug.Log("Server address: " + server_address_string + ":" + server_port_string);
              //mLoginClient.SetUsernameAndPassword(username_str,password_str);
              // username and password already setup in the signup flow
              mLoginClient.SetActivationCode(code_string);
              mLoginClient.ConnectToTcpServer(server_address_string,server_port_string,"ACTIVATE_REQUEST");
          }
        }
        catch (Exception e){
                Debug.Log("Failed to connect to server " + e);
        }
    }

    private void Update(){
        if (Input.GetKeyDown(KeyCode.Return))
        {
            Debug.Log("Return key was pressed.");
            if (IsLoginPanel)
                this.PlayGame();
        }
        if (Input.GetKeyDown(KeyCode.Tab)){
            Selectable next = Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift) ?
            mEventSystem.currentSelectedGameObject.GetComponent<Selectable>().FindSelectableOnUp() :
            mEventSystem.currentSelectedGameObject.GetComponent<Selectable>().FindSelectableOnDown();
            if (next != null)
            {
                InputField inputfield = next.GetComponent<InputField>();
                if (inputfield != null)
                inputfield.OnPointerClick(new PointerEventData(mEventSystem));
                mEventSystem.SetSelectedGameObject(next.gameObject);
            }
            //Here is the navigating back part:
            else {
                next =  Selectable.allSelectables[0];
                mEventSystem.SetSelectedGameObject(next.gameObject);
            }
        }
    }
    private LoginClient mLoginClient;
    private WorldClient mWorldClient;
    private ChatClient mChatClient;
    private GameObject mMessageBox;
    private GameObject mSignupDialog;
    private GameObject mActivateDialog;
    private GameObject mLoadingWindow;
    private GameObject mToggle;
    private void Start()
    {
        CreateAndInitLocalizedStrings();
        mEventSystem = EventSystem.current;
        IsLoginPanel = true;
        // setup the login client
        GameObject login_client_object = GameObject.FindGameObjectsWithTag("LoginClient")[0];
        mLoginClient = login_client_object.GetComponent<LoginClient>();
        mLoginClient.SetMainMenu(this);
        // setup the world client
        GameObject world_client_object = GameObject.FindGameObjectsWithTag("WorldClient")[0];
        mWorldClient = world_client_object.GetComponent<WorldClient>();
        mWorldClient.SetMainMenu(this);
        // setup the chat client
        GameObject chat_client_object = GameObject.FindGameObjectsWithTag("ChatClient")[0];
        mChatClient = chat_client_object.GetComponent<ChatClient>();
        mChatClient.SetMainMenu(this);

        mMessageBox = GameObject.Find("MessageBox");
        Debug.Assert(mMessageBox!=null);
        mMessageBox.transform.localScale = new Vector3(0, 0, 0);

        mSignupDialog = GameObject.Find("SignupDialog");
        Debug.Assert(mSignupDialog!=null);
        //         mSignupDialog.transform.localScale = new Vector3(0, 0, 0);
        mToggle = GameObject.Find("Toggle");

        mActivateDialog = GameObject.Find("ActivateDialog");
        Debug.Assert(mActivateDialog!=null);
        mActivateDialog.transform.localScale = new Vector3(0, 0, 0);
        InputField userLoginInput = GameObject.Find("UsernameInputField").GetComponent<InputField>();
        userLoginInput.Select();
        userLoginInput.ActivateInputField();
    }
    void Awake(){
        //var translatedText = LocalizationSettings.StringDatabase.GetLocalizedString("PLAY_BUTTON");
        //Debug.Log("Translated Text: " + translatedText);
    }
    private IDictionary<string,LocalizedString> mLocalizedStringMappings;



    public void ShowMessageBox(string title,string text, bool localize = false)
        {
            if (mLoadingWindow != null)
                mLoadingWindow.transform.localScale = new Vector3(0f, 0f, 0f);
            string final_title_string = title;
            string final_text_string  = text;
            Text TitleText = GameObject.Find("MsgBoxTitle").GetComponent<Text>();
            Text BodyText = GameObject.Find("MsgBoxText").GetComponent<Text>();
            if (localize){

                var localizedTitle = LocalizationSettings.StringDatabase.GetLocalizedStringAsync("MainMenu", title);
                if (localizedTitle.IsDone)
                    final_title_string = localizedTitle.Result;
                else
                    localizedTitle.Completed += (o) => TitleText.text = o.Result;

                var localizedText = LocalizationSettings.StringDatabase.GetLocalizedStringAsync("MainMenu", text);
                if (localizedText.IsDone)
                    final_text_string = localizedText.Result;
                else
                    localizedText.Completed += (o) => BodyText.text = o.Result;
            }
            Debug.Assert(TitleText!=null);
            TitleText.text = final_title_string;
            Debug.Assert(BodyText!=null);
            BodyText.text = final_text_string;
            mMessageBox.transform.localScale = new Vector3(1f, 1f, 1f);
    }

    public void ButtonArrowGeneroClick()
    {
        Text generoText = GameObject.Find("MaleOrFemale").GetComponent<Text>();
        Debug.Assert(generoText != null);
        string aux;
        if (generoText.text == "HOMBRE" || generoText.text == "UOMO" || generoText.text == "MALE" || generoText.text == "HOMME" || generoText.text == "HOMEM")
            aux = "FEMALE";
        else
            aux = "MALE";
        var generoLoc = LocalizationSettings.StringDatabase.GetLocalizedStringAsync("MainMenu", aux);
        if (generoLoc.IsDone)
            generoText.text = generoLoc.Result;
        else
            generoLoc.Completed += (o) => generoText.text = o.Result;
        
        generoText.text = generoLoc.Result;
    }
    public void ButtonArrowRazaLeftClick()
    {
        Text generoText = GameObject.Find("Raza").GetComponent<Text>();
        Debug.Assert(generoText != null);
        for (int i=0; i < strRaza.Length; i++)
        {
            if (strRaza[i] == generoText.text)
            {
                string aux;
                if (i == 0)
                {
                    aux = strRaza[strRaza.Length - 1];
                    Debug.Log("LEFTRAZA*********************************************1: " + aux);
                }
                else
                {
                    aux = strRaza[i - 1];
                    Debug.Log("LEFTRAZA*********************************************2");
                }
                var razaLoc = LocalizationSettings.StringDatabase.GetLocalizedStringAsync("MainMenu", aux + "_TEXT");
                if (razaLoc.IsDone)
                    generoText.text = razaLoc.Result;
                else
                    razaLoc.Completed += (o) => generoText.text = o.Result;
                generoText.text = razaLoc.Result;
                Debug.Log("LEFTRAZA*********************************************3");
                return;
            }
        }
    }
    public void ButtonArrowRazaRightClick()
    {
        Text generoText = GameObject.Find("Raza").GetComponent<Text>();
        Debug.Assert(generoText != null);
        for (int i = 0; i < strRaza.Length; i++)
        {
            string aux;
            if (strRaza[i] == generoText.text)
            {
                if (i == (strRaza.Length - 1))
                {
                    aux = strRaza[0];
                }
                else
                {
                    aux = strRaza[i + 1];
                }
                var razaLoc = LocalizationSettings.StringDatabase.GetLocalizedStringAsync("MainMenu", aux);
                if (razaLoc.IsDone)
                    generoText.text = razaLoc.Result;
                else
                    razaLoc.Completed += (o) => generoText.text = o.Result;
                generoText.text = razaLoc.Result;
                return;
            }
        }
    }

    public void CreateAccount(){
        Debug.Log("CreateAccount");
        InputField signup_username_input    = GameObject.Find("SignUpUsernameInputField").GetComponent<InputField>();
        InputField signup_password_input    = GameObject.Find("SignUpPasswordInputField").GetComponent<InputField>();
        InputField signup_confirm_password_input    = GameObject.Find("SignUpConfirmPasswordInputField").GetComponent<InputField>();
        InputField signup_first_name_input  = GameObject.Find("SignUpFirstNameInputField").GetComponent<InputField>();
        InputField signup_last_name_input   = GameObject.Find("SignUpLastNameInputField").GetComponent<InputField>();
        InputField signup_email_input       = GameObject.Find("SignUpEmailInputField").GetComponent<InputField>();
        InputField signup_confirm_email_input       = GameObject.Find("SignUpConfirmEmailInputField").GetComponent<InputField>();
        InputField signup_dob_input         = GameObject.Find("SignUpDOBInputField").GetComponent<InputField>();
        InputField signup_pob_input         = GameObject.Find("SignUpPOBInputField").GetComponent<InputField>();
        InputField signup_secretq1_input    = GameObject.Find("SignUpSecretQ1InputField").GetComponent<InputField>();
        InputField signup_secretq2_input    = GameObject.Find("SignUpSecretQ2InputField").GetComponent<InputField>();
        InputField signup_secreta1_input    = GameObject.Find("SignUpSecretA1InputField").GetComponent<InputField>();
        InputField signup_secreta2_input    = GameObject.Find("SignUpSecretA2InputField").GetComponent<InputField>();
        InputField signup_mobile_input      = GameObject.Find("SignUpMobileInputField").GetComponent<InputField>();
        Dropdown signup_language_dropdown   = GameObject.Find("SignUpLanguageDropdown").GetComponent<Dropdown>();
        Debug.Assert(signup_email_input != null);
        Debug.Assert(signup_confirm_email_input != null);
        Debug.Assert(signup_username_input!=null);
        Debug.Assert(signup_password_input!=null);
        Debug.Assert(signup_confirm_password_input != null);
        Debug.Assert(signup_first_name_input!=null);
        Debug.Assert(signup_last_name_input!=null);
        Debug.Assert(signup_language_dropdown!=null);
        Debug.Assert(signup_dob_input!=null);
        Debug.Assert(signup_pob_input!=null);
        Debug.Assert(signup_secretq1_input!=null);
        Debug.Assert(signup_secretq2_input!=null);
        Debug.Assert(signup_secreta2_input!=null);
        Debug.Assert(signup_secreta1_input!=null);
        Debug.Assert(signup_mobile_input!=null);
        string username_str             = signup_username_input.text;
        string password_str             = signup_password_input.text;
        string confirm_password_str     = signup_confirm_password_input.text;
        string first_name_string        = signup_first_name_input.text;
        string last_name_string         = signup_last_name_input.text;
        string email_string             = signup_email_input.text;
        string confirm_email_string     = signup_confirm_email_input.text;
        string dob_string               = signup_dob_input.text;
        string pob_string               = signup_pob_input.text;
        string secretq1_string          = signup_secretq1_input.text;
        string secretq2_string          = signup_secretq2_input.text;
        string secreta2_string          = signup_secreta1_input.text;
        string secreta1_string          = signup_secreta2_input.text;
        string mobile_string            = signup_mobile_input.text;
        //string language_string          = signup_language_input.text;
        var drop_value = signup_language_dropdown.value;
        //Change the message to say the name of the current Dropdown selection using the value
        string language_string = signup_language_dropdown.options[drop_value].text;
        if (email_string == null || !email_string.Contains("@"))
        {
            this.ShowMessageBox("INPUT_ERROR_TITLE", "INVALID_EMAIL", true);
            return;
        }
        if (confirm_email_string == null || (email_string != confirm_email_string))
        {
            //this.ShowMessageBox("INPUT_ERROR_TITLE", "INVALID_CONFIRM_EMAIL", true);
            this.ShowMessageBox("INPUT_ERROR_TITLE", "INVALID_CONFIRM_EMAIL", true);
            return;
        }
        if (username_str == null || username_str.Length<3){
            this.ShowMessageBox("INPUT_ERROR_TITLE","INPUT_ERROR_INVALID_USER",true);
            return;
        }
        if(password_str == null || password_str.Length<6 || !password_str.All(char.IsLetterOrDigit))
        {
            this.ShowMessageBox("INPUT_ERROR_TITLE","INPUT_ERROR_INVALID_PASSWORD",true);
            return;
        }
        if (confirm_password_str == null || confirm_password_str != password_str)
        {
            this.ShowMessageBox("INPUT_ERROR_TITLE", "INPUT_ERROR_INVALID_CONFIRM_PASSWORD", true);
            return;
        }
        if (first_name_string == null || last_name_string == null)
        {
            this.ShowMessageBox("INPUT_ERROR_TITLE", "INVALID_FIRST_LAST_NAME", true);
            return;
        }
        if (mobile_string == null)
        {
            this.ShowMessageBox("INPUT_ERROR_TITLE", "INVALID_FIRST_LAST_NAME", true);
            return;
        }
        if(!mToggle.GetComponent<Toggle>().isOn)
        {
            this.ShowMessageBox("INPUT_ERROR_TITLE", "TERMS_NOT_ACCEPTED", true);
            return;
        }

        try {
            mLoginClient.SetUsernameAndPassword(username_str,password_str);

            Dictionary<string, string> signup_data = new Dictionary<string,string>
            {
                { "USERNAME", username_str },
        		{ "PASSWORD", password_str },
        		{ "FIRST_NAME", first_name_string },
        		{ "LAST_NAME", last_name_string },
                { "EMAIL", email_string },
                { "DOB", dob_string },
                { "POB", pob_string },
                { "MOBILE", mobile_string },
                { "LANGUAGE", language_string },
                { "SECRETQ1", secretq1_string },
                { "SECRETQ2", secretq2_string },
                { "SECRETA2", secreta2_string },
                { "SECRETA1", secreta1_string },
            };
            mLoginClient.SetSignupData(signup_data);
            //Attempt to connect to game Server
            if( mLoginClient.IsConnected()){
                mLoginClient.AttemptToSignup();
            }
            else {
                Debug.Log("Server address: " + services_server_address + ":" + services_server_port);
                mLoginClient.ConnectToTcpServer(services_server_address, services_server_port, "SIGNUP_REQUEST");
            }
        }
        catch (Exception e){
                   Debug.Log("Failed to connect to server " + e);
        }
    }

    public void PlayGame(){
      InputField username_input       = GameObject.Find("UsernameInputField").GetComponent<InputField>();
      InputField password_input       = GameObject.Find("PasswordInputField").GetComponent<InputField>();
      Debug.Assert(username_input!=null);
      Debug.Assert(password_input!=null);
      string username_str             = username_input.text;
      string password_str             = password_input.text;

      mLoadingWindow = GameObject.Find("MessageLoading");
      Debug.Assert(mLoadingWindow != null);
      mLoadingWindow.transform.localScale = new Vector3(1f, 1f, 1f);

      if (username_str == null || username_str.Length<3){
          this.ShowMessageBox("INPUT_ERROR_TITLE","INPUT_ERROR_INVALID_USER",true);
          return;
      }
      if(password_str == null || password_str.Length<3){
          this.ShowMessageBox("INPUT_ERROR_TITLE","INPUT_ERROR_INVALID_PASSWORD",true);
          return;
      }

      try {
        //Attempt to connect to game Server
        if( mLoginClient.IsConnected()){
            mLoginClient.AttemptToLogin();
        }
        else {
            Debug.Log("Server address: " + services_server_address + ":" + services_server_port);
            mLoginClient.SetUsernameAndPassword(username_str,password_str);
            mLoginClient.ConnectToTcpServer(services_server_address, services_server_port, "LOGIN_REQUEST");
        }
      }
      catch (Exception e){
			     Debug.Log("Failed to connect to server " + e);
      }
    }
    public void QuitGame(){
        //Debug.Log("QuitGame");
        Application.Quit();
    }
    public void ShowTermsAndConditions()
    {
        Debug.Log("ShowTermsAndConditions");
        this.ShowMessageBox("TERMS_CONDITIONS_TITLE", "TERMS_CONDITIONS_TEXT", true);
    }
    public void ResendActivationCode()
    {
        Debug.Log("public void ResendActivationCode()");
        InputField username_input = GameObject.Find("SignUpUsernameInputField").GetComponent<InputField>();
        InputField email_input = GameObject.Find("SignUpEmailInputField").GetComponent<InputField>();
        Debug.Assert(username_input != null);
        Debug.Assert(email_input != null);
        string username_str = username_input.text;
        string email_str = email_input.text;

        try
        {
            //Attempt to connect to game Server
            if (mLoginClient.IsConnected())
            {
                mLoginClient.AttemptToReSendCode();
            }
            else
            {
                Debug.Log("Server address: " + services_server_address + ":" + services_server_port);
                mLoginClient.ConnectToTcpServer(services_server_address, services_server_port, "CODE_REQUEST");
            }
        }
        catch (Exception e)
        {
            Debug.Log("Failed to connect to server " + e);
        }
    }
}
