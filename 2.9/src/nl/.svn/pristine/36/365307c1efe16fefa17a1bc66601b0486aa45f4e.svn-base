package nl.bron
{
	public class HostSite
	{
		private var _frameId: int;
		private var _cells: Array;		// array of HostCell
		private var _param: Object;
		
		/**
		 * cells: array of HostCell
		 */
		public function get cells(): Array { return _cells; }
		public function get parms(): Object { return _param; }
		public function get frameId(): int { return _frameId; }
		
		public function HostSite(frameId: int)
		{
			_frameId = frameId;
			_cells = new Array;
			_param = new Object();
		}
		
		public function find(id: int): Boolean
		{
			return true;
		}

	/*	"sites": [
			{"frameId":  2, "cells":[0]		},
			{"frameId": 32, "cells":[1,4]	},
			{"frameId": 80, "cells":[2,5]	},
			{"frameId":120, "cells":[3,6]	}
		] */
		public static function createAllSites(container: brContainer, sites: Array): void
		{
			for each (var item: Object in sites) {
				var site: HostSite = new HostSite(item.frameId);
				container.sites.push(site);
				container.forEachCell(function (cell: HostCell): void {
					for each (var id: int in item.cells) {
						if (id == cell.ID) {
							site._cells.push(cell);
							cell.site = site;
							break;
						}
					}
				});
			}
		}

	/*	"shared":[
			{"cells":[1,2]},
			{"cells":[3,6,20]}
		] */
		public static function setupSharedCells(container: brContainer, shared: Array): void
		{
			//
		}
	}
}