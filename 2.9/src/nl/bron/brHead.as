package nl.bron
{
	import flash.events.Event;

	import nl.paint.sayMouth;

	public class brHead extends brCell
	{
		private var m_bUseMouth : Boolean;
		private var self : brHead;
		private var m_oMouth : sayMouth;

	    public function brHead()
	    {
			super();
			m_bUseMouth = true;
			self = this;
			if(_hostCell.filtersName) _hostCell.filtersName = _hostCell.filtersName;
	    }

		public function createMouth(p_aMarkers : Array) : void
		{
			if (!_hostCell) throw new Error("hostCell is null");
			
			if (m_bUseMouth)
			{
				if (_hostCell.actor)
				{
					if (null != m_oMouth)
					{
						if (contains(m_oMouth))
						{
							removeChild(m_oMouth);
						}
						m_oMouth = null;
					}
					m_oMouth = new sayMouth(self, p_aMarkers);
					m_oMouth.R.visible = false;
					addChild(m_oMouth);
				}
				else
				{
					throw new Error('mouth cannot be created without a head image');
				}
			}
		}

	    public function say(v : Number = 1, c : int = 2, o : int = 0): void
	    {
			if (null != m_oMouth)
			{
				m_oMouth.setMouth(_hostCell.actor);
				m_oMouth.say(v, c, o);
				m_oMouth.addEventListener("SAYMOUTH_SAYED", function(e : Event) : void { m_oMouth.clearMouth(); });
			}
	    }

		public function set mouth(p_oMouth : sayMouth): void
		{
			if ((null != m_oMouth) && (contains(m_oMouth)))
			{
				removeChild(m_oMouth);
				m_oMouth = null;
			}

			m_oMouth = p_oMouth;
			if (null != m_oMouth)
			{
				addChild(m_oMouth);
			}
		}

		public function get mouth(): sayMouth
		{
			return m_oMouth;
		}

		override public function copyEditParam(dest : Object, src : Object) : void
		{
			dest.hidden = src.hidden;
			dest.name = src.name;
			dest.mouth = src.mouth;
			dest.url = src.url
		}
	}
}
class HeadParam
{
	public var url: String;
	public var mouth: Array;
}
