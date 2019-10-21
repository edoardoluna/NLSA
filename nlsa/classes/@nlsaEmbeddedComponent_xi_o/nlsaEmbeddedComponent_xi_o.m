classdef nlsaEmbeddedComponent_xi_o < nlsaEmbeddedComponent_o ...
                                    & nlsaEmbeddedComponent_xi
%NLSAEMBEDDEDCOMPONENT_XI_E  Class definition and constructor of NLSA 
% time-lagged embedded component with phase space velocity and "overlap" 
% storage of embedded data
%
% Modified 2014/08/04    

    methods
        
        %% CLASS CONSTRUCTOR
        function obj = nlsaEmbeddedComponent_xi_o( varargin )
            % Initialize nlsaEmbeddedComponent_o superclass to default object
            % since its properties are subset of the properties of 
            % nlsaEmbeddedComponent_xi
            obj@nlsaEmbeddedComponent_o();
            obj@nlsaEmbeddedComponent_xi( varargin{ : } );
        end


        %% CONCATENATECOMPONENTTAGS
        % Revert to nlsaEmbeddedComponent_xi parent to avoid conflict
        function tag = concatenateComponentTags( obj )
            tag = concatenateComponentTags@nlsaEmbeddedComponent_xi( obj );
        end

        %% TAGS
        % Revert to nlsaEmbeddedComponent_xi parent to avoid conflict
        function tag = getTag( obj )
            tag = getTag@nlsaEmbeddedComponent_xi( obj );
        end

        %% DEFAULT TAGS
        % Revert to nlsaEmbeddedComponent_xi parent to avoid conflict
        function obj = setDefaultTag( obj )
            obj = setDefaultTag@nlsaEmbeddedComponent_xi( obj );
        end

        %% MAKE DIRECTORIES
        % Revert to nlsaEmbeddedComoponent_xi parent to avoid conflict
        function mkdir( obj )
            mkdir@nlsaEmbeddedComponent_xi( obj );
        end
    end
end
    
