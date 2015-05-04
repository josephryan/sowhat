library(ape)

#' Generates the "zero-constrained" tree described by Susko 2014 
#' (http://dx.doi.org/10.1093/molbev/msu039)
#' 
#' @param phy_resolved A fully resolved phylogeny stored as a phylo object, e.g. an ML 
#' tree.
#' @param phy_constraint A partially resolved constraint tree.
#' @param epsilon 
#' @return A phylo object containing a tree that is the same as phy_resolved, except that 
#' the length of edges that are incompatible with phy_constraint are replaced with epsilon.
#' @examples
#' zc <- zero_constrained( ml, constraint )
zero_constrained <- function ( phy_resolved, phy_constraint, epsilon=0.000001 ){
	phy_resolved$edge.length[ incompatible_edges(  phy_resolved, phy_constraint ) ] <- epsilon
	return( phy_resolved )
}

#' Identify the edges in one phylo object that are incompatible with the edges in another 
#' phylo object. Requires the same tip labels for each tree.
#' 
#' @param phy1 The tree under consideration
#' @param phy2 The tree to be compared to
#' @return A boolean vector corresponding to the edges in phy1. Each element is FALSE if 
#' the edge is compatible with phy2, or TRUE if incompatible.
incompatible_edges <- function( phy1, phy2 ){
	
	# First check to see that the two trees have the same tips
	if( setequal(phy1$tip.label, phy2$tip.label) == FALSE ) {
		stop("Trees do not have the same tip names.")
	}

	bi1 = get_bipartitions( phy1 )
	bi2 = get_bipartitions( phy2 )
	
	incompat = lapply( bi1, is_incompatible_with_set, bi_list=bi2, phy=phy1 )
	
	return ( unlist( incompat ) )
}

#' Check if bipartition bi is incompatible with the bipartitions in bi_list. 
#' Each bipartition is defined as a vector of the names of the tips on one side of the
#' bipartition.
#' 
#' @param bi The query bipartition.
#' @param bi_list A list of the bipartitions to be compared against.
#' @param phy A phylo object describing a tree that includes all tips under investigation. 
#' This is used to infer the other half of each bipartition.
#' @return TRUE if bi is incompatible with any bipartition in bi_list, otherwise FALSE.
is_incompatible_with_set <- function( bi, bi_list, phy ) {

	incompatible <- lapply( bi_list, are_bipartitions_incompatible, bi2=bi, phy=phy )
	return ( any( unlist( incompatible ) ) )
}

#' Check if two bipartitions drawn from trees with the same tips are incompatible with eachother. 
#' Each bipartition is defined as a vector of the names of the tips on one side of the
#' bipartition.
#' 
#' @param bi1 The first bipartition.
#' @param bi2 The second bipartition.
#' @param phy A phylo object describing a tree that includes all tips under investigation. 
#' This is used to infer the other half of each bipartition.
#' @return TRUE if bi1 is incompatible with bi2, otherwise FALSE.
are_bipartitions_incompatible <- function( bi1, bi2, phy ) {
	
	labels = phy$tip.label
	
	# Take the left side of the bipartition, as given
	left1  = bi1
	
	# Take the right side of the bipartition as all taxa not in the left side
	right1 = labels[ ! labels %in% left1 ]
	
	# Do the same for the second bipartition
	left2  = bi2
	right2 = labels[ ! labels %in% left2 ]
	
	# Bipartition 1 is compatible with Bipartition 2 if either side of Bipartition 1 
	# is a subset of either side of Bipartition 2
	
	left1_compat  = all( left1 %in% left2 ) | all( left1 %in% right2 )
	right1_compat = all( right1 %in% left2 ) | all( right1 %in% right2 )
	
	compatible = left1_compat | right1_compat
	
	return( ! compatible )
}

#' Get tips and labels of a phylo object.
#' 
#' @param phy A phylo object.
#' @return A vector of all the tips, annotated with their names
tips <- function(phy) {

	t <- phy$edge[ ! phy$edge[,2] %in% phy$edge[,1] ,2]
	t <- t[order(t)]
	
	names(t) <- phy$tip.label
	
	return(t)
}

#' Get all the descendants of a given node in a tree.
#' 
#' @param phy A phylo object that specifies the tree.
#' @param a The number of a node in phy.
#' @param keep_node If FALSE, do not include a in the result. 
#' @return A vector of nodes (specified by number) that are descendants of a. Includes
#' internal and tip nodes.
descendants <- function(phy, a, keep_node=FALSE) {
	# returns a vector of all the descendants of node a, including tips and internal nodes
	# Based on a breadth-first search
	q <- c(a)
	d <- c()
	while (length(q)>0){
		# dequeue first item
		n <- q[1]
		q <- q[q != n]
		
		# add it to the descendants vector
		d <- append(d, n)
		
		# add it's descendants to the queue
		q <- append(q, phy$edge[phy$edge[,1] == n,2])
	}
	
	# Remove the original source node from the list
	if ( ! keep_node ){
		d <- d[d != a ]
	}
	return(d)
}

#' Get all the tips that are descendants of a given node in a tree.
#' 
#' @param phy A phylo object that specifies the tree.
#' @param a The number of a node in phy.
#' @return A vector of tip nodes (specified by number) that are descendants of a. If a is 
#' a tip, it is the sole element of this vector.
tip_descendants <- function(phy, a) {
	# returns a vector of all the tips that are descendants of a
	t <- tips(phy)
	return( t[ t %in% descendants( phy, a, keep_node=TRUE ) ] )
}

#' Get a bipartition, described as a vector of tip numbers, from a specified tree and 
#' edge number.
#' 
#' @param phy A phylo object that specifies the tree.
#' @param edge The number of the edge that defines the bipartition.
#' @return A vector of tip nodes (specified by numbers) that define one half of the 
#' bipartition (the other half is the set of tip nodes that are not in this vector).
bipartition_for_edge <- function( phy, edge ){

	# Not certain which of the two nodes that make up the edge is ancestor and which is 
	# descendant. Descendant will have fewer descendant tips, so pick the node with the 
	# fewest descendants.
	
	left_node  <- phy$edge[edge,1]
	right_node <- phy$edge[edge,2]
	
	left_tips <- tip_descendants( phy, left_node )
	right_tips <- tip_descendants( phy, right_node )
	
	if ( length( left_tips ) < length( right_tips ) ){
		return( left_tips )
	}
	else {
		return( right_tips )
	}

}

#' Get a bipartition, described as a vector of tip labels, from a specified tree and 
#' edge number.
#' 
#' @param phy A phylo object that specifies the tree.
#' @param edge The number of the edge that defines the bipartition.
#' @return A vector of tip nodes (specified by labels) that define one half of the 
#' bipartition (the other half is the set of tip nodes that are not in this vector).
bipartition_for_edge_by_label <- function( edge, phy ){
	
	return( phy$tip.label[ bipartition_for_edge( phy, edge ) ]	 )

}

#' Get a list of all the bipartitions in a tree.
#' 
#' @param phy A phylo object that specifies the tree.
#' @return A list of bipartitions for the tree. The order of the list corresponds to the 
#' edges in phy$edge. Bipartitions are specified as a vector of the tip labels that make 
#' up one half of the bipartition.
get_bipartitions <- function( phy ){
	# Takes a tree, returns a list of 
	edge_nums = as.list( 1:nrow( phy$edge ) )
	
	return( lapply( edge_nums, bipartition_for_edge_by_label, phy=phy ) )
	
}
