{ pkgs, ... }: { 
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    # Install OpenJDK 11 (for running the App Engine project in Java)
    pkgs.openjdk11
    
    # Install Apache Ant (for building the project)
    pkgs.ant

    # Install Google Cloud SDK (includes tools for App Engine)
    pkgs.google-cloud-sdk

    # Optionally, you can include other packages like Git, Node.js, etc.
    # pkgs.git
    # pkgs.nodejs_20
  ];

  # Sets environment variables in the workspace
  env = {
    # Set JAVA_HOME for Java 11
    JAVA_HOME = "${pkgs.openjdk11}/lib/openjdk";
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # Optional: If you're using a specific editor extension (e.g., Vim key bindings)
      # "vscodevim.vim"
    ];

    # Enable previews (if you need web previews in IDX)
    previews = {
      enable = true;
      previews = {
        # Example web preview
        web = {
          # Run "java_dev_appserver.sh" for App Engine local development
          command = ["${pkgs.google-cloud-sdk}/bin/java_dev_appserver.sh" "--port=8888" "--address=0.0.0.0" "appengine/build/war/"];
          manager = "web";
          env = {
            # Set any additional environment variables here
            PORT = "$PORT";
          };
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Install Google App Engine components for Java
        gcloud-app-engine-install = "gcloud components install app-engine-java";
      };
      # Runs when the workspace is (re)started
      onStart = {
        # Optionally authenticate gcloud if needed
        gcloud-auth = "gcloud auth login";

        # Optionally set up gcloud project configuration
        gcloud-config = "gcloud config set project YOUR_PROJECT_ID";

        # Start the local App Engine development server
        start-app-engine = "${pkgs.google-cloud-sdk}/bin/java_dev_appserver.sh --port=8888 --address=0.0.0.0 appengine/build/war/";
      };
    };
  };
}
