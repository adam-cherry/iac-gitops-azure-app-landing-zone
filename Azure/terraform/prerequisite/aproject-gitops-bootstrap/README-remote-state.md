
# Übertragung und Verwaltung des Terraform Backends in Azure

Um das bereits erwähnte "Henne - Ei" Problem in Azure zu lösen und den State des Backends zentral und sicher zu speichern, bedarf es folgender Schritte:

1. Im Verzeichnis azure_backend wird sich nach deinem initialen Deployment die Datei terraform.tfstate befinden. Benenne diese Datei in backend.tfstate um.

2. Logge dich in das Azure Portal ein und wähle den Storage Account aus, den du zuvor mit Hilfe von Terraform deployed hast.

3. Anschließend wählst du den Container tfstate-backend aus und lädst die backend.tfstate Datei hoch.

4. Jetzt erstellst du in deinem Ordner azure_backend eine neue Datei mit dem Namen backend.tf mit folgendem Inhalt

```
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "satfstates8g8"
    container_name       = "tfstate-backend"
    key                  = "backend.tfstate"
  }
}
````

5. Bitte passe die Werte (z. B. storage_account_name) entsprechend deiner Konfiguration an.
6. Die im Ordner azure_backend befindlichen .tfstate Dateien und den Ordner .terraform kannst du jetzt löschen.
7. Führe den folgenden Befehl aus, um das backend erfolgreich zu initialisieren terraform init -migrate-state
8. Mit terraform plan kannst du sichergehen, dass alles erfolgreich geklappt hat. Die Ausgabe sollte wie folgt aussehen:


Herzlichen Glückwunsch!
Damit hast du dein standardisiertes und durch Terraform gemanagtes Backend in Azure bereitgestellt.

__Hinweis:__
Solltest du deine aktuelle IP-Adresse in der terraform.tfvars Datei angegeben haben, dann musst du diese regelmäßig im Portal → Storage Account → Networking aktualisieren bzw. deine jeweils aktuelle IP-Adresse hinterlegen.
Ansonsten hast du keinen Zugriff auf die Terraform State Dateien.
