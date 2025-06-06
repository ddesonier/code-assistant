# 🤖 AI Code Assistant

This application provides a Streamlit-based interface to interact with Azure OpenAI. It can analyze code, generate README content, explain code, and process custom prompts.

---

## ✨ Features

- **🤝 Azure OpenAI Integration**  
  Uses Azure OpenAI API to process code, generate feedback, and produce refined code snippets.
- **📝 README Generation**  
  Automatically creates a well-structured README comparing and explaining the provided code.
- **🔍 Code Explanation**  
  Provides detailed explanations for code snippets, identifying potential improvements.
- **📚 Retrieval Augmented Generation (RAG) Support**  
  Uploads content to an Azure Storage Account connected to an AI Search Indexer, enabling retrieval of additional context for more precise output.

---

## 🛠️ Requirements

- 🐍 Python 3.8 or higher  
- ☁️ Azure OpenAI endpoint and API key  
- 💾 Azure Storage Account with an AI Search Indexer  
- 🔎 Azure Search (endpoint, index, indexer)  
- 🏗️ Azure App Service Plan and App Service  
- 💻 Azure CLI installed  
- 🐳 Docker Desktop installed  

---

## ⚙️ Azure Resource Setup

### 1️⃣ Create Supporting Services

- **💾 Storage Account, Container, and Blob Folder**
  - Ensure your development system IP has access.
  - Upload a sample data file to the container (required for AI Search Index).

- **🤖 Azure OpenAI (AOAI) Account**
  - Deploy a model within your AOAI account.

- **🔎 Azure AI Search Instance**
  - Use public connectivity.
  - Connect your data:
    - Data Source: Storage Blob
    - Data Source Name: Use something meaningful
    - Data to Extract: All Metadata
    - Connection String: From Storage Account Keys
    - Container Name & Blob Folder: As created above
  - Customize target index and use default values for indexer creation.

- **📦 Azure Container Registry (ACR)**
- **🛠️ App Service Plan**

---

## 🔐 Permissions

- **🔎 AI Search**
  - Enable Managed Identity under Settings.
  - Assign these roles (at Subscription or Resource Group scope):
    - Storage Blob Data Contributor
    - Cognitive Services OpenAI Contributor
    - Search Service Contributor
    - Search Index Data Reader

- **🤖 Azure OpenAI**
  - Enable Managed Identity under Resource Management.
  - Assign these roles:
    - Search Index Data Reader
    - Search Service Contributor

---

## 🧩 Application Environment Variables

Create a `.env` file with the following variables:

- `AZURE_OPENAI_ENDPOINT`
- `AZURE_OPENAI_CHATGPT_DEPLOYMENT`
- `AZURE_OPENAI_KEY`
- `AZURE_OPENAI_API_VERSION`
- `AZURE_STORAGE_ACCOUNT_NAME`
- `CONTAINER_NAME`
- `AZURE_AI_SEARCH_ENDPOINT`
- `AZURE_AI_SEARCH_KEY`
- `AZURE_AI_SEARCH_INDEX`
- `AZURE_AI_SEARCH_INDEXER`

---

## 💻 Installation (Using PowerShell Terminal in VSCode)

1. **Clone the repository:**
   ```
   git clone reponame.git
   cd code-assistant
   ```

2. **Create and activate a virtual environment:**
   ```
   python -m venv venv
   venv\Scripts\activate  # For Windows
   ```

3. **Install dependencies:**
   ```
   pip install -r requirements.txt
   ```

4. **Create a `.env` file and add your Application Environment Variables.**

---

## 🚀 Run Application Locally

1. **Run the application:**
   ```
   streamlit run app.py
   ```
2. **Interact with the UI:**
   - Enter your **Task Description** and **Your Code**, then pick an action from the dropdown:
     - 🧠 Analyze Code  
     - 📝 Create Readme  
     - 🔍 Explain Code  
     - 💬 Submit Prompt  
   - Click **Submit** to send your request to Azure OpenAI.  
   - The **Output** on the right shows the generated feedback and refined code.

---

## 🧠 Explanation

- **`process_code`** analyzes and refines the code using Azure OpenAI.  
- **`create_readme`** generates a well-structured README, describing the purpose of the code and including usage instructions.  
- **`explain_code`** provides a step-by-step explanation of the code’s functionality.  
- **`submit_prompt`** allows submission of custom prompts to Azure OpenAI.  
- The application also uploads content to an Azure Storage Account connected to an AI Search Indexer, allowing a Retrieval Augmented Generation (RAG) approach to incorporate additional context.

---

## 🐳 Build Docker Container and Push to ACR

1. **Build Docker Container**
   ```
   docker build --no-cache -t code-assistant:latest . 
   ```
2. **Push to ACR**
   - Log in to Azure
     ```
     az login
     ```
   - Set the subscription (if needed)
     ```
     az account set --subscription "<your-subscription-name-or-id>"
     ```
   - Log in to your ACR
     ```
     az acr login --name <your-acr-name>
     ```
   - Tag your local image for ACR
     ```
     docker tag code-assistant:latest <your-acr-name>.azurecr.io/code-assistant:latest
     ```
   - Push the image to ACR
     ```
     docker push <your-acr-name>.azurecr.io/code-assistant:latest
     ```
   - Verify the image is in ACR
     ```
     az acr repository list --name <your-acr-name> --output table
     ```

---

# 🛠️ Create and Deploy a Linux Container App Service from ACR (Azure Portal)

## 📦 Create an App Service Plan

1. Go to the Azure Portal and search for **"App Service Plans"**.
2. Click **"Create"**.
3. Choose your **Subscription** and **Resource Group**.
4. Enter a **Name** for your plan.
5. Select **Linux** as the Operating System.
6. Choose a **Region** and a **Pricing Tier** (e.g., B1 for basic).
7. Click **"Review + Create"**, then **"Create"**.

---

## 🌐 Create the Web App

1. Search for **"App Services"** and click **"Create"**.
2. Fill in the following:
   - **Subscription** and **Resource Group**
   - **Name** (must be globally unique)
   - **Publish**: Select **Docker Container**
   - **Operating System**: Linux
   - **Region**: Same as your App Service Plan
   - **App Service Plan**: Select the one you created
3. Under the **Docker** tab:
   - **Image Source**: Azure Container Registry
   - **Registry**: Select your ACR
   - **Image and Tag**: Choose your container image and tag
4. Click **"Review + Create"**, then **"Create"**.

---

## ✅ Verify Deployment

1. Once deployed, go to the **App Service**.
2. Click **"Browse"** to open your app in a new tab.

---

## 🛡️ Update Application Settings (Manually or using the update_app_settings.ps1 script)

### If running script, just run and validate Environment Variables have been populated

### 1️⃣ Navigate to Your App Service
- In Azure Portal - AppServices, search for **"App Services"** and select your app.

---

### 2️⃣ Open Configuration
- In the left-hand menu, click **"Configuration"** under the **Settings** section.

---

### 3️⃣ Add or Update Environment Variables

Under the **Application settings** tab, add the following variables:

| Name                            | Value (example or placeholder)         |
|----------------------------------|----------------------------------------|
| AZURE_OPENAI_ENDPOINT           | `https://<your-openai-endpoint>`       |
| AZURE_OPENAI_CHATGPT_DEPLOYMENT | `gpt-4-deployment-name`                |
| AZURE_OPENAI_KEY                | `your-openai-api-key`                  |
| AZURE_OPENAI_API_VERSION        | `2024-04-01-preview`                   |
| AZURE_STORAGE_ACCOUNT_NAME      | `yourstorageaccount`                   |
| CONTAINER_NAME                  | `yourcontainername`                    |
| AZURE_AI_SEARCH_ENDPOINT        | `https://<your-search-endpoint>`       |
| AZURE_AI_SEARCH_KEY             | `your-search-api-key`                  |
| AZURE_AI_SEARCH_INDEX           | `your-index-name`                      |
| AZURE_AI_SEARCH_INDEXER         | `your-indexer-name`                    |

> 🔐 **Note**: Keep sensitive values like keys secure. Use Key Vault references if needed.

---

### 4️⃣ Save and Restart
- Click **"Save"** at the top.
- Confirm the prompt to restart the app for changes to take effect.

---

## 🤝 Contributing

1. Fork this repository.  
2. Create a new branch for your feature:  
   ```
   git checkout -b feature/my-feature
   ```
3. Commit your changes:  
   ```
   git commit -m "Add new feature"
   ```
4. Push to the branch:  
   ```
   git push origin feature/my-feature
   ```
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).