(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
        :parameters (?r - robot ?l0 - location ?l1 - location)
        :precondition (and (at ?r ?l0) (no-robot ?l1) (connected ?l0 ?l1))
        :effect (and (no-robot ?l0) (at ?r ?l0))
    )
    
    (:action robotMoveWithPallette
        :parameters (?r - robot ?p - pallette ?l0 - location ?l1 - location)
        :precondition (and (at ?r ?l0) (no-robot ?l1) (connected ?l0 ?l1) (at ?p ?l0))
        :effect (and (no-pallette ?l0) (no-robot ?l0) (at ?r ?l1) (at ?p ?l1))
    )
    
    (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?p - pallette ?s - shipment ?si - saleitem ?o -order )
        :precondition (and (packing-location ?l) (orders ?o ?si) (not (includes ?s ?si)) (contains ?p ?si) (at ?p ?l))
        :effect (and (not (contains ?p ?si)) (includes ?s ?si) (not (orders ?o ?si)))
    )
    
    (:action completeShipment
        :parameters (?s - shipment ?l - location ?o - order)
        :precondition (and (packing-at ?s ?l) (ships ?s ?o) (complete ?s) (started ?s))
        :effect (and (not (packing-at ?s ?l)) (available ??l))
    )

)
