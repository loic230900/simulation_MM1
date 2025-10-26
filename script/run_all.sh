#!/bin/bash
# Script principal pour exécuter le pipeline complet M/M/1
# Usage: ./run_all.sh [--quick] [--full]

set -e  # Arrêter en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage des messages
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Fonction d'aide
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --quick    Exécution rapide avec peu de simulations (pour test)"
    echo "  --full     Exécution complète avec toutes les simulations"
    echo "  --help     Afficher cette aide"
    echo ""
    echo "Par défaut, exécute le pipeline complet."
}

# Fonction de vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier que les scripts existent
    if [ ! -f "script/run_simulations.sh" ]; then
        log_error "script/run_simulations.sh introuvable"
        exit 1
    fi
    
    
    # Vérifier que le programme Java est compilé
    if [ ! -f "MM1.class" ]; then
        log_error "MM1.class introuvable. Veuillez compiler le programme Java avec 'make compile'"
        exit 1
    fi
    
    if [ ! -f "script/aggregate_results.py" ]; then
        log_error "script/aggregate_results.py introuvable"
        exit 1
    fi
    
    # Vérifier que Python3 est installé
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 n'est pas installé"
        exit 1
    fi
    
    # Vérifier que gnuplot est installé
    if ! command -v gnuplot &> /dev/null; then
        log_error "gnuplot n'est pas installé"
        exit 1
    fi
    
    log_success "Tous les prérequis sont satisfaits"
}

# Fonction de configuration rapide
setup_quick_mode() {
    log_info "Configuration du mode rapide..."
    
    # Sauvegarder les valeurs originales
    export ORIG_LAMBDA_VALUES="${LAMBDA_VALUES[@]}"
    export ORIG_N_VALUES="${N_VALUES[@]}"
    export ORIG_LAMBDA_FOR_N_VALUES="${LAMBDA_FOR_N_VALUES[@]}"
    export ORIG_REPLICATIONS=$REPLICATIONS
    
    # Définir des valeurs réduites pour le test
    export LAMBDA_VALUES=(1 3 5)
    export N_VALUES=(1000 10000)
    export LAMBDA_FOR_N_VALUES=(1 3)
    export REPLICATIONS=3
    
    log_info "Mode rapide configuré :"
    log_info "  LAMBDA_VALUES: ${LAMBDA_VALUES[@]}"
    log_info "  N_VALUES: ${N_VALUES[@]}"
    log_info "  LAMBDA_FOR_N_VALUES: ${LAMBDA_FOR_N_VALUES[@]}"
    log_info "  REPLICATIONS: $REPLICATIONS"
}

# Fonction de restauration des valeurs originales
restore_original_values() {
    if [ ! -z "$ORIG_LAMBDA_VALUES" ]; then
        log_info "Restauration des valeurs originales..."
        export LAMBDA_VALUES=("${ORIG_LAMBDA_VALUES[@]}")
        export N_VALUES=("${ORIG_N_VALUES[@]}")
        export LAMBDA_FOR_N_VALUES=("${ORIG_LAMBDA_FOR_N_VALUES[@]}")
        export REPLICATIONS=$ORIG_REPLICATIONS
    fi
}

# Fonction principale
main() {
    local start_time=$(date +%s)
    
    echo "=========================================="
    echo "🚀 PIPELINE COMPLET M/M/1 SIMULATION"
    echo "=========================================="
    
    # Traitement des arguments
    case "${1:-}" in
        --help|-h)
            show_help
            exit 0
            ;;
        --quick)
            setup_quick_mode
            ;;
        --full)
            log_info "Mode complet activé"
            ;;
        "")
            log_info "Mode par défaut (complet)"
            ;;
        *)
            log_error "Option inconnue: $1"
            show_help
            exit 1
            ;;
    esac
    
    # Vérification des prérequis
    check_prerequisites
    
    # Créer le répertoire graphes s'il n'existe pas
    mkdir -p graphes
    
    # Étape 1: Simulations
    log_info "Étape 1/3: Exécution des simulations..."
    log_info "Ceci peut prendre plusieurs heures..."
    
    (cd script && bash run_simulations.sh)
    
    if [ $? -eq 0 ]; then
        log_success "Simulations terminées avec succès"
    else
        log_error "Erreur lors des simulations"
        exit 1
    fi
    
    # Étape 2: Agrégation des résultats
    log_info "Étape 2/3: Agrégation des résultats..."
    
    python3 script/aggregate_results.py
    
    if [ $? -eq 0 ]; then
        log_success "Agrégation terminée avec succès"
    else
        log_error "Erreur lors de l'agrégation"
        exit 1
    fi
    
    # Étape 3: Génération des graphiques
    log_info "Étape 3/3: Génération des graphiques..."
    
    (cd script && bash generate_graphs.sh)
    
    if [ $? -eq 0 ]; then
        log_success "Génération des graphiques terminée avec succès"
    else
        log_error "Erreur lors de la génération des graphiques"
        exit 1
    fi
    
    # Restauration des valeurs originales
    restore_original_values
    
    # Affichage des statistiques finales
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo ""
    echo "=========================================="
    log_success "PIPELINE TERMINÉ AVEC SUCCÈS !"
    echo "=========================================="
    log_info "Durée totale: ${duration}s"
    log_info "Résultats bruts: script/sim_results.csv"
    log_info "Graphiques générés: graphes/"
    log_info "Données agrégées: script/*.dat"
    
    # Afficher le nombre de graphiques générés
    local graph_count=$(ls graphes/*.png 2>/dev/null | wc -l)
    log_info "Nombre de graphiques générés: $graph_count"
    
    echo ""
    log_info "Pour nettoyer les résultats, exécutez: script/clean_all.sh"
}

# Exécution du script principal
main "$@"
