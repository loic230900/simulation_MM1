#!/bin/bash
# Script pour générer tous les graphiques M/M/1
# Usage: ./generate_graphs.sh

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

# Fonction de vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier que gnuplot est installé
    if ! command -v gnuplot &> /dev/null; then
        log_error "gnuplot n'est pas installé"
        exit 1
    fi
    
    # Vérifier que les fichiers .plt existent
    local plt_count=$(ls *.plt 2>/dev/null | wc -l)
    if [ $plt_count -eq 0 ]; then
        log_error "Aucun fichier .plt trouvé dans le répertoire courant"
        exit 1
    fi
    
    log_success "Prérequis satisfaits ($plt_count scripts .plt trouvés)"
}

# Fonction de création du répertoire graphes
setup_output_directory() {
    log_info "Configuration du répertoire de sortie..."
    
    # Créer le répertoire graphes s'il n'existe pas
    mkdir -p ../graphes
    
    # Nettoyer les anciens graphiques
    if [ "$(ls ../graphes/*.png 2>/dev/null | wc -l)" -gt 0 ]; then
        log_warning "Suppression des anciens graphiques..."
        rm -f ../graphes/*.png
    fi
    
    log_success "Répertoire ../graphes/ prêt"
}

# Fonction de génération d'un graphique
generate_graph() {
    local plt_file="$1"
    local graph_name=$(basename "$plt_file" .plt)
    
    log_info "Génération de $graph_name..."
    
    if gnuplot "$plt_file" 2>/dev/null; then
        log_success "✓ $graph_name généré"
        return 0
    else
        log_warning "✗ Erreur lors de la génération de $graph_name"
        return 1
    fi
}

# Fonction de génération de tous les graphiques
generate_all_graphs() {
    log_info "Génération de tous les graphiques..."
    
    local success_count=0
    local error_count=0
    local total_count=0
    
    # Liste des graphiques à générer (dans l'ordre de priorité)
    local graph_scripts=(
        "plot_error_analysis.plt"
        "plot_confidence_intervals.plt"
        "plot_waiting_proportion.plt"
        "plot_performance_overview.plt"
        "plot_sensitivity_analysis.plt"
        "plot_performance_flow.plt"
        "plot_robustness_analysis.plt"
        "plot_variance_analysis.plt"
        "plot_stddev_analysis.plt"
        "plot_variance_comparison.plt"
        "plot_distribution_analysis.plt"
        "plot_median_vs_mean.plt"
        "plot_range_analysis.plt"
        "plot_correlation_matrix.plt"
        "plot_precision_analysis.plt"
        "plot_normality_tests.plt"
    )
    
    # Générer chaque graphique
    for plt_file in "${graph_scripts[@]}"; do
        if [ -f "$plt_file" ]; then
            total_count=$((total_count + 1))
            if generate_graph "$plt_file"; then
                success_count=$((success_count + 1))
            else
                error_count=$((error_count + 1))
            fi
        else
            log_warning "Fichier $plt_file introuvable, ignoré"
        fi
    done
    
    # Générer les graphiques restants (s'il y en a)
    log_info "Génération des graphiques supplémentaires..."
    for plt_file in *.plt; do
        if [ -f "$plt_file" ]; then
            local found=false
            for script in "${graph_scripts[@]}"; do
                if [ "$plt_file" = "$script" ]; then
                    found=true
                    break
                fi
            done
            
            if [ "$found" = false ]; then
                total_count=$((total_count + 1))
                if generate_graph "$plt_file"; then
                    success_count=$((success_count + 1))
                else
                    error_count=$((error_count + 1))
                fi
            fi
        fi
    done
    
    # Affichage des statistiques
    echo ""
    log_info "Statistiques de génération :"
    log_info "  Total: $total_count graphiques"
    log_success "  Succès: $success_count"
    if [ $error_count -gt 0 ]; then
        log_warning "  Erreurs: $error_count"
    fi
    
    return $error_count
}

# Fonction de vérification des résultats
verify_results() {
    log_info "Vérification des résultats..."
    
    local graph_count=$(ls ../graphes/*.png 2>/dev/null | wc -l)
    
    if [ $graph_count -gt 0 ]; then
        log_success "$graph_count graphiques générés dans ../graphes/"
        
        # Afficher la liste des graphiques générés
        log_info "Graphiques générés :"
        ls -la ../graphes/*.png | while read -r line; do
            local filename=$(echo "$line" | awk '{print $NF}')
            local size=$(echo "$line" | awk '{print $5}')
            log_info "  $(basename "$filename") ($size octets)"
        done
    else
        log_error "Aucun graphique généré !"
        return 1
    fi
}

# Fonction principale
main() {
    local start_time=$(date +%s)
    
    echo "=========================================="
    echo "📊 GÉNÉRATION DES GRAPHIQUES M/M/1"
    echo "=========================================="
    
    # Vérification des prérequis
    check_prerequisites
    
    # Configuration du répertoire de sortie
    setup_output_directory
    
    # Génération de tous les graphiques
    generate_all_graphs
    local generation_result=$?
    
    # Vérification des résultats
    verify_results
    local verification_result=$?
    
    # Affichage des statistiques finales
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo ""
    echo "=========================================="
    if [ $generation_result -eq 0 ] && [ $verification_result -eq 0 ]; then
        log_success "GÉNÉRATION TERMINÉE AVEC SUCCÈS !"
    else
        log_warning "GÉNÉRATION TERMINÉE AVEC DES AVERTISSEMENTS"
    fi
    echo "=========================================="
    log_info "Durée: ${duration}s"
    log_info "Graphiques disponibles dans: ../graphes/"
    
    return $generation_result
}

# Exécution du script principal
main "$@"
